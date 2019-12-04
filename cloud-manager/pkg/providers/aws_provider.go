package providers

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
)

type awsProvider struct {
	Provider
	name    string
	profile string
	region  string
	session *session.Session
}

func NewAwsProvider(name, profile, region string) (Provider, error) {
	authSession, err := newSession(profile, region)

	if err != nil {
		return nil, err
	}

	return &awsProvider{
		name:    name,
		profile: profile,
		region:  region,
		session: authSession,
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
	svc := ec2.New(ap.session)
	input := &ec2.DescribeInstancesInput{
		Filters: []*ec2.Filter{
			{
				Name:   aws.String("private-dns-name"),
				Values: aws.StringSlice([]string{privateDnsName}),
			},
		},
	}
	response, err := svc.DescribeInstances(input)
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

func (ap *awsProvider) TerminateInstance(instanceName string) (bool, error) {
	instance, err := ap.GetInstance(instanceName)
	if err != nil {
		return false, err
	}
	if instance == nil {
		return false, nil
	}

	svc := ec2.New(ap.session)
	input := &ec2.TerminateInstancesInput{
		InstanceIds: []*string{instance.InstanceId},
	}
	result, terminationErr := svc.TerminateInstances(input)
	if terminationErr != nil {
		return false, err
	}
	return *result.TerminatingInstances[0].CurrentState.Name == "shutting-down", nil
}
