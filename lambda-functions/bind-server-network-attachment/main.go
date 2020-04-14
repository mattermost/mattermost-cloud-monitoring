package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/autoscaling"
	"github.com/aws/aws-sdk-go/service/ec2"

	log "github.com/sirupsen/logrus"
)

func main() {
	lambda.Start(handler)
}

func handler(ctx context.Context, autoScalingEvent events.AutoScalingEvent) {
	if autoScalingEvent.DetailType == "EC2 Instance-launch Lifecycle Action" {
		instanceID := autoScalingEvent.Detail["EC2InstanceId"].(string)
		lifecycleHookName := autoScalingEvent.Detail["LifecycleHookName"].(string)
		autoScalingGroupName := autoScalingEvent.Detail["AutoScalingGroupName"].(string)

		vpcID, subNetID, err := getVpcSubNetID(instanceID)
		if err != nil {
			log.WithError(err).Errorf("Error getting the subnet from instanceID=%s", instanceID)
			completeLifecycleActionFailure(lifecycleHookName, autoScalingGroupName, instanceID)
			return
		}
		log.Infof("vpcID=%s Subnet=%s\n", vpcID, subNetID)

		networkInterfaceID, err := getNetWorkInterface(vpcID, subNetID)
		if err != nil {
			log.WithError(err).Errorf("Error getting the subnet from instanceID=%s", instanceID)
			completeLifecycleActionFailure(lifecycleHookName, autoScalingGroupName, instanceID)
			return
		}
		log.Infof("networkInterfaceID=%s\n", networkInterfaceID)

		attachID, err := attachInterface(networkInterfaceID, instanceID)
		if err != nil {
			log.WithError(err).Errorf("Error getting the subnet from instanceID=%s\n", instanceID)
			completeLifecycleActionFailure(lifecycleHookName, autoScalingGroupName, instanceID)
			return
		}
		log.Infof("attachID=%s\n", attachID)

		completeLifecycleActionSuccess(lifecycleHookName, autoScalingGroupName, instanceID)
	}
}

func completeLifecycleActionFailure(hookName, groupName, instanceID string) error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return err
	}

	svc := autoscaling.New(sess)

	input := &autoscaling.CompleteLifecycleActionInput{
		AutoScalingGroupName:  aws.String(groupName),
		LifecycleActionResult: aws.String("ABANDON"),
		InstanceId:            aws.String(instanceID),
		LifecycleHookName:     aws.String(hookName),
	}

	_, err = svc.CompleteLifecycleAction(input)
	if err != nil {
		return err
	}

	log.Warnf("Lifecycle hook ABANDONED for %s\n", instanceID)

	return nil
}

func completeLifecycleActionSuccess(hookName, groupName, instanceID string) error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return err
	}

	svc := autoscaling.New(sess)

	input := &autoscaling.CompleteLifecycleActionInput{
		AutoScalingGroupName:  aws.String(groupName),
		LifecycleActionResult: aws.String("CONTINUE"),
		InstanceId:            aws.String(instanceID),
		LifecycleHookName:     aws.String(hookName),
	}

	_, err = svc.CompleteLifecycleAction(input)
	if err != nil {
		return err
	}

	log.Infof("Lifecycle hook CONTINUED for %s\n", instanceID)

	return nil
}

func attachInterface(networkInterfaceID, instanceID string) (string, error) {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return "", err
	}
	svc := ec2.New(sess)

	input := &ec2.AttachNetworkInterfaceInput{
		DeviceIndex:        aws.Int64(1),
		InstanceId:         aws.String(instanceID),
		NetworkInterfaceId: aws.String(networkInterfaceID),
	}

	result, err := svc.AttachNetworkInterface(input)
	if err != nil {
		return "", err
	}

	return *result.AttachmentId, nil
}

func getNetWorkInterface(vpcID, subNetID string) (string, error) {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return "", err
	}

	svc := ec2.New(sess)

	input := &ec2.DescribeNetworkInterfacesInput{
		MaxResults: aws.Int64(200),
		Filters: []*ec2.Filter{
			{
				Name: aws.String("vpc-id"),
				Values: []*string{
					aws.String(vpcID),
				},
			},
			{
				Name: aws.String("subnet-id"),
				Values: []*string{
					aws.String(subNetID),
				},
			},
			{
				Name: aws.String("tag:BindServer"),
				Values: []*string{
					aws.String("true"),
				},
			},
		},
	}

	result, err := svc.DescribeNetworkInterfaces(input)
	if err != nil {
		return "", nil
	}

	for _, networkInterface := range result.NetworkInterfaces {
		if *networkInterface.Status == "available" {
			return *networkInterface.NetworkInterfaceId, nil
		}
	}
	return "", fmt.Errorf("No Network Interface available")
}

func getVpcSubNetID(instanceID string) (string, string, error) {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return "", "", err
	}

	svc := ec2.New(sess)
	input := &ec2.DescribeInstancesInput{
		InstanceIds: []*string{
			aws.String(instanceID),
		},
	}
	result, err := svc.DescribeInstances(input)
	if err != nil {
		return "", "", err
	}

	return *result.Reservations[0].Instances[0].VpcId, *result.Reservations[0].Instances[0].SubnetId, nil
}
