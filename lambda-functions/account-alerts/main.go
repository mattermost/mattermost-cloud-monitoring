package main

import (
	"fmt"
	"os"
	"strconv"
	"time"

	clientcmdapi "k8s.io/client-go/tools/clientcmd/api"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials/stscreds"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/aws/aws-sdk-go/service/sts"
	"github.com/aws/aws-sdk-go/service/sts/stsiface"
	"github.com/pkg/errors"

	log "github.com/sirupsen/logrus"
)

type clientConfig struct {
	Client      *clientcmdapi.Config
	ClusterName string
	ContextName string
	roleARN     string
	sts         stsiface.STSAPI
}

type environmentVariables struct {
	MinSubnetFreeIPs int64
}

func main() {
	lambda.Start(handler)
}

func handler() {

	envVars, err := validateAndGetEnvVars()
	if err != nil {
		log.WithError(err).Error("Environment variable validation failed")
		err = sendMattermostErrorNotification(err, "Environment variable validation failed")
		if err != nil {
			log.WithError(err).Error("Failed to send Mattermost error notification")
		}
		os.Exit(1)
	}

	log.Info("Getting existing Provisioning Subnet IP limits")
	err = checkProvisioningSubnetIPLimits(*envVars)
	if err != nil {
		log.WithError(err).Error("Unable to get the number of available VPCs")
	}
}

// validateEnvironmentVariables is used to validate the environment variables needed by Blackbox target discovery.
func validateAndGetEnvVars() (*environmentVariables, error) {
	envVars := &environmentVariables{}
	minSubnetFreeIPs := os.Getenv("MIN_SUBNET_FREE_IPs")
	if len(minSubnetFreeIPs) == 0 {
		return nil, errors.Errorf("MIN_SUBNET_FREE_IPs environment variable is not set")
	}

	number, err := strconv.Atoi(minSubnetFreeIPs)
	if err != nil {
		return nil, err
	}
	envVars.MinSubnetFreeIPs = int64(number)

	return envVars, nil
}

// newSession creates a new STS session
func newSession() *session.Session {
	config := aws.NewConfig()
	config = config.WithCredentialsChainVerboseErrors(true)

	opts := session.Options{
		Config:                  *config,
		SharedConfigState:       session.SharedConfigEnable,
		AssumeRoleTokenProvider: stscreds.StdinTokenProvider,
	}

	stscreds.DefaultDuration = 30 * time.Minute

	return session.Must(session.NewSessionWithOptions(opts))
}

// checkAuth checks the AWS access
func checkAuth(stsAPI stsiface.STSAPI) (string, error) {
	input := &sts.GetCallerIdentityInput{}
	output, err := stsAPI.GetCallerIdentity(input)
	if err != nil {
		return "", errors.Wrap(err, "checking AWS STS access – cannot get role ARN for current session")
	}
	iamRoleARN := *output.Arn
	log.Debugf("Role ARN for the current session is %s", iamRoleARN)
	return iamRoleARN, nil
}

// getSetProvisioningSubnetIPLimits is used to get the Provisioning VPCs Subnet IP limits and set the CW metric data.
func checkProvisioningSubnetIPLimits(envVars environmentVariables) error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return err
	}

	svc := ec2.New(sess)

	vpcs, err := svc.DescribeVpcs(&ec2.DescribeVpcsInput{
		Filters: []*ec2.Filter{
			{
				Name: aws.String("tag:Available"),
				Values: []*string{
					aws.String("false"),
				},
			},
		},
	})
	if err != nil {
		return err
	}

	for _, vpc := range vpcs.Vpcs {
		log.Infof("Exploring VPC %s", *vpc.VpcId)
		subnets, err := svc.DescribeSubnets(&ec2.DescribeSubnetsInput{
			Filters: []*ec2.Filter{
				{
					Name: aws.String("vpc-id"),
					Values: []*string{
						aws.String(*vpc.VpcId),
					},
				},
			},
		})
		if err != nil {
			return err
		}
		for _, subnet := range subnets.Subnets {
			if *subnet.AvailableIpAddressCount < envVars.MinSubnetFreeIPs {
				log.Infof("Subnet %s has low number of available IPs (%d)", *subnet.SubnetId, *subnet.AvailableIpAddressCount)
				sendMattermostAlertNotification(fmt.Sprintf("Subnet %s has low number of available IPs (%d)", *subnet.SubnetId, *subnet.AvailableIpAddressCount), "VPC Subnets")
			}
		}
	}

	return nil
}
