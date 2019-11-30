package providers

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
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
