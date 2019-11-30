package providers

import (
	"fmt"

	"github.com/pkg/errors"
)

type Provider struct {
	name string
}

func NewProvider(name string) (*Provider, error) {
	switch name {
	case "aws":
		return NewAwsProvider(name)
	default:
		return nil, errors.New(fmt.Sprintf("Unsupported provider found: %s", name))
	}
}
