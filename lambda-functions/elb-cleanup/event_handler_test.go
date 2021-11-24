package main

import (
	"context"
	"errors"
	"testing"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/elb"
	"github.com/aws/aws-sdk-go/service/elbv2"
	"github.com/golang/mock/gomock"
	"github.com/mattermost/mattermost-cloud-monitoring/tree/MM-38981-cleanup-unused-LBs/lambda-functions/mocks"
	"github.com/sirupsen/logrus"
	"github.com/stretchr/testify/assert"
)

func TestHandle(t *testing.T) {
	gmctrl := gomock.NewController(t)
	awsResourcer := mocks.NewMockResourcer(gmctrl)
	eventHandler := NewEventHandler(90, awsResourcer, false, logrus.New())
	defer gmctrl.Finish()

	sampleLB := elbv2.LoadBalancer{
		LoadBalancerArn:       aws.String("arn:aws:elasticloadbalancing:us-west-2:123456789012:loadbalancer/app/my-load-balancer/50dc6c495c0c9188"),
		DNSName:               aws.String("my-load-balancer-1234566.us-west-2.elb.amazonaws.com"),
		CanonicalHostedZoneId: aws.String("Z2P70J7EXAMPLE"),
		VpcId:                 aws.String("vpc-test-id"),
		LoadBalancerName:      aws.String("web"),
		Type:                  aws.String("application"),
	}
	testCases := []struct {
		description string
		ctx         func() context.Context
		setup       func(ctx context.Context)
		expected    func(err error)
	}{
		{
			description: "List ELBs, failed to list ELBs",
			ctx:         func() context.Context { return context.TODO() },
			setup: func(ctx context.Context) {
				awsResourcer.EXPECT().
					ListUnusedElbs(gomock.Any()).
					Return([]elbv2.LoadBalancer{}, errors.New("failed to list LBs")).MaxTimes(1)

			},
			expected: func(err error) {
				assert.NotNil(t, err)
				assert.Contains(t, err.Error(), "failed to list LBs")
			},
		},
		{
			description: "Failed to delete ELBs",
			ctx:         func() context.Context { return context.TODO() },
			setup: func(ctx context.Context) {
				awsResourcer.EXPECT().
					ListUnusedElbs(gomock.Any()).
					Return([]elbv2.LoadBalancer{
						sampleLB,
					}, nil).MaxTimes(2)

				awsResourcer.EXPECT().DeleteElbs(gomock.Any(), []elbv2.LoadBalancer{sampleLB}).
					Return(errors.New("Unable to delete Load balancer")).MaxTimes(1)

			},
			expected: func(err error) {
				assert.NotNil(t, err)
				assert.Contains(t, err.Error(), "Unable to delete Load balancer")
			},
		},
		{
			description: "Successful Delete ELBs",
			ctx:         func() context.Context { return context.TODO() },
			setup: func(ctx context.Context) {
				awsResourcer.EXPECT().
					ListUnusedElbs(gomock.Any()).
					Return([]elbv2.LoadBalancer{
						sampleLB,
					}, nil).MaxTimes(3)
				awsResourcer.EXPECT().
					ListUnUsedClassiclbs(gomock.Any()).
					Return([]*elb.LoadBalancerDescription{}, nil)
				awsResourcer.EXPECT().
					DeleteClassiclbs(gomock.Any(), gomock.Any()).
					Return(nil)
				awsResourcer.EXPECT().DeleteElbs(gomock.Any(), []elbv2.LoadBalancer{
					sampleLB,
				}).Return(nil).MaxTimes(2)

			},
			expected: func(err error) {
				assert.NoError(t, err)

			},
		},
		{
			description: "List Classic , failed to list Calssic LBs",
			ctx:         func() context.Context { return context.TODO() },
			setup: func(ctx context.Context) {
				awsResourcer.EXPECT().
					ListUnUsedClassiclbs(gomock.Any()).
					Return([]*elb.LoadBalancerDescription{}, errors.New("failed to list Calssic LBs")).MaxTimes(1)
			},
			expected: func(err error) {
				assert.NotNil(t, err)
				assert.Contains(t, err.Error(), "failed to list Calssic LBs")
			},
		},
		{
			description: "Successful Delete Classic ELBs",
			ctx:         func() context.Context { return context.TODO() },
			setup: func(ctx context.Context) {
				awsResourcer.EXPECT().
					ListUnusedElbs(gomock.Any()).
					Return([]elbv2.LoadBalancer{
						sampleLB,
					}, nil).MaxTimes(4)
				awsResourcer.EXPECT().
					ListUnUsedClassiclbs(gomock.Any()).
					Return([]*elb.LoadBalancerDescription{&elb.LoadBalancerDescription{LoadBalancerName: sampleLB.LoadBalancerName}}, nil).MaxTimes(2)
				awsResourcer.EXPECT().
					DeleteClassiclbs(gomock.Any(), []*elb.LoadBalancerDescription{&elb.LoadBalancerDescription{LoadBalancerName: sampleLB.LoadBalancerName}}).
					Return(nil)
				awsResourcer.EXPECT().DeleteElbs(gomock.Any(), []elbv2.LoadBalancer{
					sampleLB,
				}).Return(nil).MaxTimes(2)

			},
			expected: func(err error) {
				assert.NoError(t, err)

			},
		},
	}

	for _, testCase := range testCases {
		t.Run(testCase.description, func(t *testing.T) {
			testCase.setup(testCase.ctx())

			err := eventHandler.Handle(testCase.ctx(), events.CloudWatchEvent{})
			testCase.expected(err)
		})
	}
}
