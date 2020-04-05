package providers

import (
	"fmt"

	"github.com/aws/aws-sdk-go/service/ec2"
)

type Provider interface {
	TerminateInstance(instanceName string, forceTermination bool) (bool, error)
	GetName() string
	GetInstance(privateDnsName string) (*ec2.Instance, error)
}

func NewProvider(name, profile, region string) (Provider, error) {
	switch name {
	case "aws":
		return NewAwsProvider(name, profile, region, nil)
	default:
		return nil, fmt.Errorf("Unsupported provider found: %s", name)
	}
}
