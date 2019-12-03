package providers

import (
	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/aws/aws-sdk-go/service/eks"
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

func (m *awsProvider) ListClusters() ([]*string, error) {
	svc := eks.New(m.session)
	input := &eks.ListClustersInput{}
	result, err := svc.ListClusters(input)

	if err != nil {
		return nil, err
	}

	return result.Clusters, nil
}

func (m *awsProvider) GetName() string {
	return m.name
}

func (m *awsProvider) ListInstances() (map[string]string, error) {
	svc := ec2.New(m.session)
	resp, err := svc.DescribeInstances(nil)
	if err != nil {
		return nil, err
	}
	fmt.Println("> Number of reservation sets: ", len(resp.Reservations))

	input := &ec2.DescribeInstancesInput{
		Filters: []*ec2.Filter{
			{
				Name: aws.String("instance-state-name"),
				Values: []*string{
					aws.String("running"),
					aws.String("pending"),
				},
			},
		},
	}
	result, err := svc.DescribeInstances(input)
	if err != nil {
		return nil, err
	}
	dnsNameIDMap := make(map[string]string)
	for _, reservation := range result.Reservations {
		for _, instance := range reservation.Instances {
			dnsNameIDMap[*instance.PrivateDnsName] = *instance.InstanceId

		}
	}
	return dnsNameIDMap, nil

}
