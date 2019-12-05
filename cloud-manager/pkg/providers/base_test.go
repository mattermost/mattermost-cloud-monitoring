package providers

import (
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"testing"
)

func TestNewProviderWhenSupportedProvider(t *testing.T) {
	provider, err := NewProvider("aws", "profile", "region")
	require.NoError(t, err, "return supported provider should not error")
	assert.Equal(t, "aws", provider.GetName())
}

func TestNewProviderWhenUnsupportedProvider(t *testing.T) {
	_, err := NewProvider("foobar", "profile", "region")
	assert.EqualError(t, err, "Unsupported provider found: foobar")
}
