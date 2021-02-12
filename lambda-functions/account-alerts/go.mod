module github.com/mattermost/mattermost-cloud-monitoring/lambda-functions/account-mattermost-alerts

go 1.15

require (
	github.com/aws/aws-lambda-go v1.13.3
	github.com/aws/aws-sdk-go v1.35.5
	github.com/mattermost/mattermost-server/v5 v5.31.1
	github.com/pkg/errors v0.9.1
	github.com/sirupsen/logrus v1.7.0
	k8s.io/apimachinery v0.20.2 // indirect
	k8s.io/client-go v11.0.0+incompatible
)
