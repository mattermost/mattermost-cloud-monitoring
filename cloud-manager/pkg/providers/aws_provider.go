package providers

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
)

func NewAwsProvider(name string) (*Provider, error) {
	return &Provider{name: name}, nil
}

func AwsAuthentication(profile, region string) (interface{}, error) {
	sess, err := session.NewSession(&aws.Config{
		Region:      aws.String(region),
		Credentials: credentials.NewSharedCredentials("", profile),
	})

	return &sess, err
}

func (m *Provider) GetName() string {
	return m.name
}
