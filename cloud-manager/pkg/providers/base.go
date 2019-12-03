package providers

import (
	"fmt"

	"github.com/pkg/errors"
)

type Provider interface {
	ListClusters() ([]*string, error)
	ListInstances() (map[string]string, error)
	GetName() string
}

func NewProvider(name, profile, region string) (Provider, error) {
	switch name {
	case "aws":
		return NewAwsProvider(name, profile, region)
	default:
		return nil, errors.New(fmt.Sprintf("Unsupported provider found: %s", name))
	}
}
