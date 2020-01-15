package main

import (
	"strconv"
	"strings"
	"time"

	clientcmdapi "k8s.io/client-go/tools/clientcmd/api"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials/stscreds"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/cloudwatch"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/aws/aws-sdk-go/service/elb"
	"github.com/aws/aws-sdk-go/service/sts"
	"github.com/aws/aws-sdk-go/service/sts/stsiface"
	"github.com/pkg/errors"

	log "github.com/sirupsen/logrus"
)

const (
	vpcID = "VPC_ID"
)

type clientConfig struct {
	Client      *clientcmdapi.Config
	ClusterName string
	ContextName string
	roleARN     string
	sts         stsiface.STSAPI
}

func main() {
	lambda.Start(handler)
}

func handler() {
	log.Info("Getting existing ELB limits")
	err := getSetELBLimits()
	if err != nil {
		log.WithError(err).Error("Unable to get the existing ELB limits and set the CloudWatch metric data")
	}

	log.Info("Getting number of existing ELBs")
	err = getSetCurrentNumberOfElbs()
	if err != nil {
		log.WithError(err).Error("Unable to get the number of existing ELBs and set the CloudWatch metric data")
	}

	log.Info("Getting number of available VPCs")
	err = getAvailableVPCs()
	if err != nil {
		log.WithError(err).Error("Unable to get the number of available VPCs")
	}

	log.Info("Getting number of provisioning VPCs")
	err = getProvisioningVPCs()
	if err != nil {
		log.WithError(err).Error("Unable to get the number of provisioning VPCs")
	}

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

// getUsername gets the username out of the AWS Lambda role arn
func getUsername(iamRoleARN string) string {
	usernameParts := strings.Split(iamRoleARN, "/")
	if len(usernameParts) > 1 {
		return usernameParts[len(usernameParts)-1]
	}
	return "iam-root-account"
}

// getELBLimits is used to get the existing ELB Limits and set the CW metric data.
func getSetELBLimits() error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return err
	}

	// Create ELB service client
	svc := elb.New(sess)

	elbLimits, err := svc.DescribeAccountLimits(&elb.DescribeAccountLimitsInput{})

	if err != nil {
		return err
	}
	currentELBLimit, err := strconv.ParseFloat(*elbLimits.Limits[0].Max, 64)
	if err != nil {
		return err
	}
	log.Info("Setting CloudWatch metric for LoadBalancerLimit")
	err = addCWMetricData("LoadBalancerLimit", currentELBLimit)
	if err != nil {
		return err
	}
	return nil
}

// getSetCurrentNumberOfElbs is used to get the live number of used ELBs and set the CW metric data.
func getSetCurrentNumberOfElbs() error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return err
	}

	svc := elb.New(sess)

	elbs, err := svc.DescribeLoadBalancers(&elb.DescribeLoadBalancersInput{})

	if err != nil {
		return err
	}
	log.Info("Setting CloudWatch metric for LoadBalancersUsed")
	err = addCWMetricData("LoadBalancersUsed", float64(len(elbs.LoadBalancerDescriptions)))
	if err != nil {
		return err
	}
	return nil
}

// getAvailableVPCs is used to get the live number of available VPCs and set the CW metric data.
func getAvailableVPCs() error {
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
					aws.String("true"),
				},
			},
		},
	})
	if err != nil {
		return err
	}
	log.Info("Setting CloudWatch metric for AvailableVPCs")
	err = addCWMetricData("AvailableVPCs", float64(len(vpcs.Vpcs)))
	if err != nil {
		return err
	}
	return nil
}

// getProvisioningVPCs is used to get the live number of provisioning VPCs and set the CW metric data.
func getProvisioningVPCs() error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return err
	}

	svc := ec2.New(sess)

	vpcs, err := svc.DescribeVpcs(&ec2.DescribeVpcsInput{
		Filters: []*ec2.Filter{
			{
				Name: aws.String("tag-key"),
				Values: []*string{
					aws.String("Available"),
				},
			},
		},
	})
	if err != nil {
		return err
	}
	log.Info("Setting CloudWatch metric for ProvisioningVPCs")
	err = addCWMetricData("ProvisioningVPCs", float64(len(vpcs.Vpcs)))
	if err != nil {
		return err
	}
	return nil
}

// addCWMetricData is used to set the CW metric data.
func addCWMetricData(metric string, value float64) error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return err
	}

	svc := cloudwatch.New(sess)
	_, err = svc.PutMetricData(&cloudwatch.PutMetricDataInput{
		MetricData: []*cloudwatch.MetricDatum{
			{
				MetricName: aws.String(metric),
				Value:      aws.Float64(value),
			},
		},
		Namespace: aws.String("AWS/Grafana"),
	})

	if err != nil {
		return err
	}
	return nil
}
