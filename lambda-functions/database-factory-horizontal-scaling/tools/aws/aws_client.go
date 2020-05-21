package aws

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
)

// newSession creates a new STS session
func awsSession(service string) (*session.Session, error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return nil, err
	}
	return sess, nil
}
