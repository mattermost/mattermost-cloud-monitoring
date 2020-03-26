package providers

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/aws/aws-sdk-go/service/ec2/ec2iface"
	"github.com/pkg/errors"
)

type awsProvider struct {
	Provider
	name      string
	profile   string
	region    string
	ec2Client ec2iface.EC2API
}

func NewAwsProvider(name, profile, region string, ec2Service ec2iface.EC2API) (Provider, error) {
	if name == "" || profile == "" || region == "" {
		return nil, errors.New("one or all required attributes(name, profile, region) is blank")
	}

	ec2Svc := ec2Service

	if ec2Svc == nil {
		authSession, err := newSession(profile, region)

		if err != nil {
			return nil, err
		}

		ec2Svc = ec2.New(authSession)
	}

	return &awsProvider{
		name:      name,
		profile:   profile,
		region:    region,
		ec2Client: ec2Svc,
	}, nil
}

func newSession(profile, region string) (*session.Session, error) {

	config := &aws.Config{
		Region:      aws.String(region),
		Credentials: credentials.NewSharedCredentials("", profile),
	}

	return session.NewSession(config)
}

func (ap *awsProvider) GetName() string {
	return ap.name
}

func (ap *awsProvider) GetInstance(privateDnsName string) (*ec2.Instance, error) {
	input := &ec2.DescribeInstancesInput{
		Filters: []*ec2.Filter{
			{
				Name:   aws.String("private-dns-name"),
				Values: aws.StringSlice([]string{privateDnsName}),
			},
		},
	}
	response, err := ap.ec2Client.DescribeInstances(input)
	if err != nil {
		return nil, err
	}
	reservations := response.Reservations
	if len(reservations) == 0 {
		return nil, nil
	}

	instances := reservations[0].Instances
	if len(instances) == 0 {
		return nil, nil
	}

	return instances[0], nil
}

func (ap *awsProvider) TerminateInstance(instanceName string, forceTermination bool) (bool, error) {
	instance, err := ap.GetInstance(instanceName)
	if err != nil {
		return false, err
	}
	if instance == nil {
		return false, nil
	}

	// Disabling the termination protection if the forceTermination flag is enabled
	if forceTermination {
		forceTerminationError := ap.disableTerminationProtection(*instance.InstanceId)
		if forceTerminationError != nil {
			return false, forceTerminationError
		}
	}

	input := &ec2.TerminateInstancesInput{
		InstanceIds: []*string{instance.InstanceId},
	}
	result, terminationErr := ap.ec2Client.TerminateInstances(input)
	if terminationErr != nil {
		return false, terminationErr
	}

	terminatingInstances := result.TerminatingInstances
	if len(terminatingInstances) == 0 {
		return false, nil
	}

	return *terminatingInstances[0].CurrentState.Name == "shutting-down", nil
}

func (ap *awsProvider) disableTerminationProtection(instanceId string) error {
	input := &ec2.ModifyInstanceAttributeInput{
		DisableApiTermination: &ec2.AttributeBooleanValue{
			Value: aws.Bool(false),
		},
		InstanceId: aws.String(instanceId),
	}

	_, err := ap.ec2Client.ModifyInstanceAttribute(input)
	return err
}
