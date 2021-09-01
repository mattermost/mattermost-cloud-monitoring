package main

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/golang/mock/gomock"
	"github.com/mattermost/mattermost-cloud-monitoring/lambda-functions/ebs-janitor/mocks"
	"github.com/sirupsen/logrus"
	"github.com/stretchr/testify/assert"
)

func TestHandle(t *testing.T) {
	gmctrl := gomock.NewController(t)
	awsResourcer := mocks.NewMockResourcer(gmctrl)
	eventHandler := NewEventHandler(90, awsResourcer, false, logrus.New())

	samples := []struct {
		description string
		ctx         func() context.Context
		setup       func(ctx context.Context)
		expected    func(err error)
	}{
		{
			description: "list volumes failed wrong volume state",
			ctx: func() context.Context {
				return context.TODO()
			},
			setup: func(ctx context.Context) {
				awsResourcer.EXPECT().
					ListVolumes(gomock.Any(), gomock.Any()).
					Return([]*ec2.Volume{}, errors.New("list resourcer error"))
			},
			expected: func(err error) {
				assert.NotNil(t, err)
				assert.Contains(t, err.Error(), "list resourcer error")
			},
		},
		{
			description: "volumes skipped by deletion for create time",
			ctx: func() context.Context {
				return context.TODO()
			},
			setup: func(ctx context.Context) {
				awsResourcer.EXPECT().
					ListVolumes(gomock.Any(), gomock.Any()).
					Return([]*ec2.Volume{
						{
							VolumeId:   aws.String("test-id"),
							CreateTime: aws.Time(time.Now()),
							SnapshotId: aws.String(""),
						},
					}, nil)
				awsResourcer.EXPECT().
					DeleteVolume(gomock.Any(), gomock.Any()).MaxTimes(0)
			},
			expected: func(err error) {
				assert.NoError(t, err)
			},
		},
		{
			description: "delete volume failed",
			ctx: func() context.Context {
				return context.TODO()
			},
			setup: func(ctx context.Context) {
				awsResourcer.EXPECT().
					ListVolumes(gomock.Any(), gomock.Any()).
					Return([]*ec2.Volume{
						{
							VolumeId:   aws.String("test-id"),
							CreateTime: aws.Time(time.Now().AddDate(0, -4, 0)),
							SnapshotId: aws.String(""),
						},
					}, nil)

				awsResourcer.EXPECT().
					DeleteVolume(gomock.Any(), aws.String("test-id")).
					Return(errors.New("delete resourcer error")).MaxTimes(1)
			},
			expected: func(err error) {
				assert.NotNil(t, err)
				assert.Contains(t, err.Error(), "delete resourcer error")
			},
		},
		{
			description: "delete volume success",
			ctx: func() context.Context {
				return context.TODO()
			},
			setup: func(ctx context.Context) {
				awsResourcer.EXPECT().
					ListVolumes(gomock.Any(), gomock.Any()).
					Return([]*ec2.Volume{
						{
							VolumeId:   aws.String("test-id"),
							CreateTime: aws.Time(time.Now().AddDate(0, -4, 0)),
							SnapshotId: aws.String(""),
						},
					}, nil)

				awsResourcer.EXPECT().
					DeleteVolume(gomock.Any(), aws.String("test-id")).
					Return(nil).MaxTimes(1)
			},
			expected: func(err error) {
				assert.NoError(t, err)
			},
		},
	}

	for _, v := range samples {
		t.Run(v.description, func(t *testing.T) {
			v.setup(v.ctx())

			err := eventHandler.Handle(v.ctx(), events.CloudWatchEvent{})

			v.expected(err)
		})
	}
}
