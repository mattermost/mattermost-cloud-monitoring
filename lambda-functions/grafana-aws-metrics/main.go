package main

import (
	"fmt"
	"strconv"
	"strings"
	"time"

	clientcmdapi "k8s.io/client-go/tools/clientcmd/api"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials/stscreds"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/autoscaling"
	"github.com/aws/aws-sdk-go/service/cloudwatch"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/aws/aws-sdk-go/service/elb"
	"github.com/aws/aws-sdk-go/service/elbv2"
	"github.com/aws/aws-sdk-go/service/iam"
	"github.com/aws/aws-sdk-go/service/rds"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/aws/aws-sdk-go/service/servicequotas"
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
	log.Info("Getting existing RDS limits and setting the CloudWatch metric data")
	err := getSetELBLimits()
	if err != nil {
		log.WithError(err).Error("Unable to get the existing ELB limits and set the CloudWatch metric data")
	}

	log.Info("Getting existing Provisioning VPC limits and setting the CloudWatch metric data")
	err = getSetProvisioningVPCLimits()
	if err != nil {
		log.WithError(err).Error("Unable to get the number of available VPCs")
	}

	log.Info("Getting existing RDS limits and setting the CloudWatch metric data")
	err = getSetRDSLimits()
	if err != nil {
		log.WithError(err).Error("Unable to get the existing RDS limits and set the CloudWatch metric data")
	}

	log.Info("Getting existing S3 limits and setting the CloudWatch metric data")
	err = getSetS3Limits()
	if err != nil {
		log.WithError(err).Error("Unable to get the existing S3 limits and set the CloudWatch metric data")
	}

	log.Info("Getting existing VPC limits and setting the CloudWatch metric data")
	err = getSetVPCLimits()
	if err != nil {
		log.WithError(err).Error("Unable to get the existing VPC limits and set the CloudWatch metric data")
	}

	log.Info("Getting existing ΙΑΜ limits and setting the CloudWatch metric data")
	err = getSetΙΑΜLimits()
	if err != nil {
		log.WithError(err).Error("Unable to get the existing ΙΑΜ limits and set the CloudWatch metric data")
	}

	log.Info("Getting existing EIP limits and setting the CloudWatch metric data")
	err = getSetEIPLimits()
	if err != nil {
		log.WithError(err).Error("Unable to get the existing EIP limits and set the CloudWatch metric data")
	}

	log.Info("Getting existing NLB and ALB limits and setting the CloudWatch metric data")
	err = getSetNLBALBLimits()
	if err != nil {
		log.WithError(err).Error("Unable to get the existing NLB and ALB limits and set the CloudWatch metric data")
	}

	log.Info("Getting existing Autoscaling limits and setting the CloudWatch metric data")
	err = getSetAutoscalingLimits()
	if err != nil {
		log.WithError(err).Error("Unable to get the existing Autoscaling limits and set the CloudWatch metric data")
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

	log.Infof("Setting CloudWatch metric for LoadBalancersLimit - %v", currentELBLimit)
	err = addCWMetricData("ElasticLoadBalancersLimit", currentELBLimit)
	if err != nil {
		return err
	}

	elbs, err := svc.DescribeLoadBalancers(&elb.DescribeLoadBalancersInput{})
	if err != nil {
		return err
	}

	log.Infof("Setting CloudWatch metric for LoadBalancersUsed - %v", float64(len(elbs.LoadBalancerDescriptions)))
	err = addCWMetricData("ElasticLoadBalancersUsed", float64(len(elbs.LoadBalancerDescriptions)))
	if err != nil {
		return err
	}

	err = utilizationmetricUtilization(float64(len(elbs.LoadBalancerDescriptions)), currentELBLimit, "ElasticLoadBalancersUtilization")
	if err != nil {
		return err
	}

	return nil
}

// getSetRDSLimits is used to get the existing RDS Limits and set the CW metric data.
func getSetRDSLimits() error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return err
	}

	// Create RDS service client
	svc := rds.New(sess)

	req, rdsAccountAttributes := svc.DescribeAccountAttributesRequest(&rds.DescribeAccountAttributesInput{})

	err = req.Send()
	if err != nil {
		return err
	}

	for _, attribute := range rdsAccountAttributes.AccountQuotas {
		metricNameLimit := fmt.Sprintf("%sLimit", *attribute.AccountQuotaName)
		metricNameUsed := fmt.Sprintf("%sUsed", *attribute.AccountQuotaName)

		log.Infof("Setting CloudWatch metric for %s - %v", metricNameLimit, float64(*attribute.Max))
		err = addCWMetricData(metricNameLimit, float64(*attribute.Max))
		if err != nil {
			return err
		}

		log.Infof("Setting CloudWatch metric for %s - %v", metricNameUsed, float64(*attribute.Used))
		err = addCWMetricData(metricNameUsed, float64(*attribute.Used))
		if err != nil {
			return err
		}

		err = utilizationmetricUtilization(float64(*attribute.Used), float64(*attribute.Max), fmt.Sprintf("%sUtilization", *attribute.AccountQuotaName))
		if err != nil {
			return err
		}
	}
	return nil
}

// getSetS3Limits is used to get the existing S3 Limits and set the CW metric data.
func getSetS3Limits() error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return err
	}

	// TODO: Commenting this out as currently the quotas are not supporting S3 limits. Will put the max default number which is 1000 buckets.

	// // Create S3 quota client
	// svc := servicequotas.New(sess)
	// quota, err := svc.GetServiceQuota(&servicequotas.GetServiceQuotaInput{QuotaCode: aws.String("L-DC2B2D3D"), ServiceCode: aws.String("s3")})
	// if err != nil {
	// 	return err
	// }

	// log.Infof("Setting CloudWatch metric for S3BucketsLimit - %v", float64(*quota.Quota.Value))
	// err = addCWMetricData("S3BucketsLimit", float64(*quota.Quota.Value))
	// if err != nil {
	// 	return err
	// }

	customMax := 1000
	log.Infof("Setting CloudWatch metric for S3BucketsLimit - %v", float64(customMax))
	err = addCWMetricData("S3BucketsLimit", float64(customMax))
	if err != nil {
		return err
	}

	// Create S3 service client
	svcS3 := s3.New(sess)
	buckets, err := svcS3.ListBuckets(&s3.ListBucketsInput{})
	if err != nil {
		return err
	}

	log.Infof("Setting CloudWatch metric for S3BucketsUsed - %v", float64(len(buckets.Buckets)))
	err = addCWMetricData("S3BucketsUsed", float64(len(buckets.Buckets)))
	if err != nil {
		return err
	}

	// err = utilizationmetricUtilization(float64(len(buckets.Buckets)), float64(*quota.Quota.Value), "S3BucketsUtilization")
	// if err != nil {
	// 	return err
	// }

	err = utilizationmetricUtilization(float64(len(buckets.Buckets)), float64(customMax), "S3BucketsUtilization")
	if err != nil {
		return err
	}

	return nil
}

// getSetVPCLimits is used to get the existing Provisioning VPC Limits and set the CW metric data.
func getSetVPCLimits() error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return err
	}

	// Create VPC quota client
	svc := servicequotas.New(sess)
	quota, err := svc.GetServiceQuota(&servicequotas.GetServiceQuotaInput{QuotaCode: aws.String("L-F678F1CE"), ServiceCode: aws.String("vpc")})
	if err != nil {
		return err
	}

	log.Infof("Setting CloudWatch metric for VPCsLimit - %v", float64(*quota.Quota.Value))
	err = addCWMetricData("VPCsLimit", float64(*quota.Quota.Value))
	if err != nil {
		return err
	}

	// Create VPC service client
	svcVPC := ec2.New(sess)
	vpcs, err := svcVPC.DescribeVpcs(&ec2.DescribeVpcsInput{})
	log.Infof("Setting CloudWatch metric for VPCsUsed - %v", float64(len(vpcs.Vpcs)))
	err = addCWMetricData("VPCsUsed", float64(len(vpcs.Vpcs)))
	if err != nil {
		return err
	}

	err = utilizationmetricUtilization(float64(len(vpcs.Vpcs)), float64(*quota.Quota.Value), "VPCsUtilization")
	if err != nil {
		return err
	}

	return nil
}

// getSetΙΑΜLimits is used to get the existing ΙΑΜ Limits and set the CW metric data.
func getSetΙΑΜLimits() error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return err
	}

	// Create ΙΑΜ Users quota client
	svcUsers := servicequotas.New(sess)
	quotaUsers, err := svcUsers.GetServiceQuota(&servicequotas.GetServiceQuotaInput{QuotaCode: aws.String("L-F55AF5E4"), ServiceCode: aws.String("iam")})
	if err != nil {
		return err
	}

	log.Infof("Setting CloudWatch metric for IAMUsersLimit - %v", float64(*quotaUsers.Quota.Value))
	err = addCWMetricData("IAMUsersLimit", float64(*quotaUsers.Quota.Value))
	if err != nil {
		return err
	}

	// Create ΙΑΜ Roles quota client
	svcRoles := servicequotas.New(sess)
	quotaRoles, err := svcRoles.GetServiceQuota(&servicequotas.GetServiceQuotaInput{QuotaCode: aws.String("L-FE177D64"), ServiceCode: aws.String("iam")})
	if err != nil {
		return err
	}

	log.Infof("Setting CloudWatch metric for IAMRolesLimit - %v", float64(*quotaRoles.Quota.Value))
	err = addCWMetricData("IAMRolesLimit", float64(*quotaRoles.Quota.Value))
	if err != nil {
		return err
	}

	// Create IAM service client
	svcIAM := iam.New(sess)

	var iamUsers []*iam.User
	var nextUser *string
	for {
		var resp *iam.ListUsersOutput
		resp, err = svcIAM.ListUsers(&iam.ListUsersInput{Marker: nextUser})
		if err != nil {
			return err
		}
		iamUsers = append(iamUsers, resp.Users...)
		if *resp.IsTruncated {
			nextUser = resp.Marker
		} else {
			break
		}
	}

	log.Infof("Setting CloudWatch metric for IAMUsersUsed - %v", float64(len(iamUsers)))
	err = addCWMetricData("IAMUsersUsed", float64(len(iamUsers)))
	if err != nil {
		return err
	}

	var iamRoles []*iam.Role
	var nextRole *string
	for {
		var resp *iam.ListRolesOutput
		resp, err = svcIAM.ListRoles(&iam.ListRolesInput{Marker: nextRole})
		if err != nil {
			return err
		}
		iamRoles = append(iamRoles, resp.Roles...)
		if *resp.IsTruncated {
			nextRole = resp.Marker
		} else {
			break
		}
	}

	log.Infof("Setting CloudWatch metric for IAMRolesUsed - %v", float64(len(iamRoles)))
	err = addCWMetricData("IAMRolesUsed", float64(len(iamRoles)))
	if err != nil {
		return err
	}

	err = utilizationmetricUtilization(float64(len(iamUsers)), float64(*quotaUsers.Quota.Value), "IAMUsersUtilization")
	if err != nil {
		return err
	}

	err = utilizationmetricUtilization(float64(len(iamRoles)), float64(*quotaRoles.Quota.Value), "IAMRolesUtilization")
	if err != nil {
		return err
	}

	return nil
}

// getSetEIPLimits is used to get the existing EIP Limits and set the CW metric data.
func getSetEIPLimits() error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return err
	}

	// Create EIP quota client
	svc := servicequotas.New(sess)
	quota, err := svc.GetServiceQuota(&servicequotas.GetServiceQuotaInput{QuotaCode: aws.String("L-0263D0A3"), ServiceCode: aws.String("ec2")})
	if err != nil {
		return err
	}

	log.Infof("Setting CloudWatch metric for EIPsLimit - %v", float64(*quota.Quota.Value))
	err = addCWMetricData("EIPsLimit", float64(*quota.Quota.Value))
	if err != nil {
		return err
	}

	// Create EIP service client
	svcEIP := ec2.New(sess)
	eips, err := svcEIP.DescribeAddresses(&ec2.DescribeAddressesInput{})
	log.Infof("Setting CloudWatch metric for EIPsUsed - %v", float64(len(eips.Addresses)))
	err = addCWMetricData("EIPsUsed", float64(len(eips.Addresses)))
	if err != nil {
		return err
	}

	err = utilizationmetricUtilization(float64(len(eips.Addresses)), float64(*quota.Quota.Value), "EIPsUtilization")
	if err != nil {
		return err
	}

	return nil
}

// getSetNLBALBLimits is used to get the existing NLB and ALB Limits and set the CW metric data.
func getSetNLBALBLimits() error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return err
	}

	// Create ELB V2 service client
	svc := elbv2.New(sess)

	limits, err := svc.DescribeAccountLimits(&elbv2.DescribeAccountLimitsInput{})

	if err != nil {
		return err
	}
	currentALBLimit := float64(0)
	currentNLBLimit := float64(0)
	for _, limit := range limits.Limits {
		if *limit.Name == "application-load-balancers" {
			currentALBLimit, err = strconv.ParseFloat(*limit.Max, 64)
			if err != nil {
				return err
			}
			log.Infof("Setting CloudWatch metric for ApplicationLoadBalancersLimit - %v", currentALBLimit)
			err = addCWMetricData("ApplicationLoadBalancersLimit", currentALBLimit)
			if err != nil {
				return err
			}
		}

		if *limit.Name == "network-load-balancers" {
			currentNLBLimit, err = strconv.ParseFloat(*limit.Max, 64)
			if err != nil {
				return err
			}
			log.Infof("Setting CloudWatch metric for NetworkLoadBalancerLimit - %v", currentNLBLimit)
			err = addCWMetricData("NetworkLoadBalancersLimit", currentNLBLimit)
			if err != nil {
				return err
			}
		}
	}

	var next *string
	nlbCounter := 0
	albCounter := 0

	for {
		existingLBs, err := svc.DescribeLoadBalancers(&elbv2.DescribeLoadBalancersInput{Marker: next})
		if err != nil {
			return err
		}

		for _, lb := range existingLBs.LoadBalancers {
			if *lb.Type == "network" {
				nlbCounter++
			}
			if *lb.Type == "application" {
				albCounter++
			}
		}

		if existingLBs.NextMarker == nil || *existingLBs.NextMarker == "" {
			break
		}

		next = existingLBs.NextMarker
	}

	log.Infof("Setting CloudWatch metric for ApplicationLoadBalancersUsed - %v", albCounter)
	err = addCWMetricData("ApplicationLoadBalancersUsed", float64(albCounter))
	if err != nil {
		return err
	}

	log.Infof("Setting CloudWatch metric for NetworkLoadBalancersUsed - %v", nlbCounter)
	err = addCWMetricData("NetworkLoadBalancersUsed", float64(nlbCounter))
	if err != nil {
		return err
	}

	err = utilizationmetricUtilization(float64(albCounter), currentALBLimit, "ApplicationLoadBalancersUtilization")
	if err != nil {
		return err
	}

	err = utilizationmetricUtilization(float64(nlbCounter), currentNLBLimit, "NetworkLoadBalancersUtilization")
	if err != nil {
		return err
	}

	return nil
}

// getSetNLBALBLimits is used to get the existing NLB and ALB Limits and set the CW metric data.
func getSetAutoscalingLimits() error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return err
	}

	// Create Autoscaling service client
	svc := autoscaling.New(sess)

	limits, err := svc.DescribeAccountLimits(&autoscaling.DescribeAccountLimitsInput{})
	if err != nil {
		return err
	}

	log.Infof("Setting CloudWatch metric for AutoScalingGroupsLimit - %v", float64(*limits.MaxNumberOfAutoScalingGroups))
	err = addCWMetricData("AutoScalingGroupsLimit", float64(*limits.MaxNumberOfAutoScalingGroups))
	if err != nil {
		return err
	}

	log.Infof("Setting CloudWatch metric for LaunchConfigurationsLimit - %v", float64(*limits.MaxNumberOfLaunchConfigurations))
	err = addCWMetricData("LaunchConfigurationsLimit", float64(*limits.MaxNumberOfLaunchConfigurations))
	if err != nil {
		return err
	}

	log.Infof("Setting CloudWatch metric for AutoScalingGroupsUsed - %v", float64(*limits.NumberOfAutoScalingGroups))
	err = addCWMetricData("AutoScalingGroupsUsed", float64(*limits.NumberOfAutoScalingGroups))
	if err != nil {
		return err
	}

	log.Infof("Setting CloudWatch metric for LaunchConfigurationsUsed - %v", float64(*limits.NumberOfLaunchConfigurations))
	err = addCWMetricData("LaunchConfigurationsUsed", float64(*limits.NumberOfLaunchConfigurations))
	if err != nil {
		return err
	}

	err = utilizationmetricUtilization(float64(*limits.NumberOfAutoScalingGroups), float64(*limits.MaxNumberOfAutoScalingGroups), "AutoScalingGroupsUtilization")
	if err != nil {
		return err
	}

	err = utilizationmetricUtilization(float64(*limits.NumberOfLaunchConfigurations), float64(*limits.MaxNumberOfLaunchConfigurations), "LaunchConfigurationsUtilization")
	if err != nil {
		return err
	}

	return nil
}

// getSetProvisioningVPCLimits is used to get the Provisioning VPCs limits and set the CW metric data.
func getSetProvisioningVPCLimits() error {
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
	freeVPCs := float64(len(vpcs.Vpcs))

	maxVpcs, err := svc.DescribeVpcs(&ec2.DescribeVpcsInput{
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
	log.Infof("Setting CloudWatch metric for ProvisioningVPCsLimit - %v", float64(len(maxVpcs.Vpcs)))
	err = addCWMetricData("ProvisioningVPCsLimit", float64(len(maxVpcs.Vpcs)))
	if err != nil {
		return err
	}

	usedVPCs := float64(len(maxVpcs.Vpcs)) - freeVPCs
	log.Infof("Setting CloudWatch metric for ProvisioningVPCsUsed - %v", usedVPCs)
	err = addCWMetricData("ProvisioningVPCsUsed", usedVPCs)
	if err != nil {
		return err
	}

	err = utilizationmetricUtilization(usedVPCs, float64(len(maxVpcs.Vpcs)), "ProvisioningVPCsUtilization")
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

func utilizationmetricUtilization(used, limit float64, metricName string) error {
	utilization := (used / limit) * float64(100)
	log.Infof("The %s is %v%%", metricName, int(utilization))
	err := addCWMetricData(metricName, float64(int(utilization)))
	if err != nil {
		return err
	}
	return nil
}
