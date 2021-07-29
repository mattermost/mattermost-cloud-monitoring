module github.com/mattermost/mattermost-cloud-monitoring/lambda-functions/grafana-aws-metrics

go 1.16

require (
	github.com/aws/aws-lambda-go v1.20.0
	github.com/aws/aws-sdk-go v1.25.4
	github.com/konsorten/go-windows-terminal-sequences v1.0.2 // indirect
	github.com/pkg/errors v0.9.1
	github.com/sirupsen/logrus v1.4.2
	k8s.io/client-go v0.21.3
)
