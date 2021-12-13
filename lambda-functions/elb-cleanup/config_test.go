package main

import (
	"testing"

	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestConfig(t *testing.T) {

	t.Run("valid config test", func(t *testing.T) {
		viper.Set("debug", true)
		viper.Set("region", "us-east1")

		err := LoadConfig(logrus.New())

		require.NoError(t, err)
		assert.Equal(t, true, cfg.Debug)
		assert.Equal(t, "us-east1", cfg.Region)
	})
	t.Run("invalid config test", func(t *testing.T) {
		viper.Set("debug", true)
		viper.Set("region", "")

		err := LoadConfig(logrus.New())
		require.EqualError(t, err, "invalid config: AWS Region should be set & has a valid value")
	})
}
