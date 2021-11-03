package main

import (
	"fmt"
	"testing"

	"github.com/golang/mock/gomock"
	// "github.com/mattermost/mattermost-cloud-monitoring/lambda-functions/elb-cleanup/mocks"
	"github.com/mattermost/mattermost-cloud-monitoring/MM-38981-cleanup-unused-LBs/lambda-functions/elb-cleanup/mocks"
	"github.com/sirupsen/logrus"
)

func TestHandle(t *testing.T) {
	gmctrl := gomock.NewController(t)
	awsResourcer := mocks.NewMockResourcer(gmctrl)
	eventHandler := NewEventHandler(90, awsResourcer, false, logrus.New())
	fmt.Println(eventHandler.expirationDays)
}
