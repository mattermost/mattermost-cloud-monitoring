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
	Debug  bool
	Region string
}

// Validate makes sure that the config makes sense
func (c *config) Validate() error {
	if len(c.Region) == 0 {
		return errors.New("AWS Region should be set & has a valid value")
	}
	return nil
}

// Set the file name of the configurations file
func init() {
	viper.AutomaticEnv()
	viper.SetEnvPrefix("elb-cleanup")

	defaults := map[string]interface{}{
		"debug":       false,
		"environment": "dev",
		"region":      "us-east-1",
	}
	for key, value := range defaults {
		viper.SetDefault(key, value)
	}
}

// LoadConfig checks file and environment variables
func LoadConfig(logger log.FieldLogger) error {
	err := viper.Unmarshal(&cfg)
	if err != nil {
		return errors.Wrap(err, "failed to load config")
	}
	return errors.Wrap(cfg.Validate(), "invalid config")
}
