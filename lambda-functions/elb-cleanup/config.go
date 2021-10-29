package main

import (
	"github.com/pkg/errors"
	log "github.com/sirupsen/logrus"
	"github.com/spf13/viper"
)

// cfg global configuration across the whole
// services
var cfg config

// config describes the available configuration
// of the running service
type config struct {
	Debug          bool
	Region         string
	ExpirationDays int `mapstructure:"expiration_days"`
}

// Validate makes sure that the config makes sense
func (c *config) Validate() error {
	return nil
}

// Set the file name of the configurations file
func init() {
	viper.AutomaticEnv()
	viper.SetEnvPrefix("elb-cleanaup")

	defaults := map[string]interface{}{
		"debug":           false,
		"environment":     "dev",
		"region":          "us-east-1",
		"expiration_days": 90,
	}
	for key, value := range defaults {
		viper.SetDefault(key, value)
	}
}

// LoadConfig checks file and environment variables
func LoadConfig(logger log.FieldLogger) error {
	err := viper.Unmarshal(&cfg)
	if err != nil {
		return errors.Wrap(err, "config load")
	}
	return errors.Wrap(cfg.Validate(), "config validate")
}
