package main

import (
	"context"
	"time"

	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/elb"
	"github.com/aws/aws-sdk-go/service/elbv2"
	"github.com/pkg/errors"
)

// awsTimeout used for the context of AWS SDK
const awsTimeout = 50 * time.Second

// Client for making AWS requests
type Client struct {
	// ec2 *ec2.EC2
	elbv2 *elbv2.ELBV2
	elb   *elb.ELB
}

// Resourcer the interface for the AWS client
type Resourcer interface {
	ListUnusedElb(context context.Context) ([]elbv2.LoadBalancer, error)
	DeleteElb(context context.Context, loadBalancerArn *string) error
	ListUnUsedClassiclb(context context.Context) ([]*elb.LoadBalancerDescription, error)
	DeleteClassiclb(context context.Context, LoadBalancerName *string) error
}

// NewClient factory method to create AWS client
func NewClient(sess *session.Session) *Client {
	return &Client{
		elbv2: elbv2.New(sess),
		elb:   elb.New(sess),
	}
}

// ListUnusedElb it will find any unused ELBs
func (c *Client) ListUnusedElb(context context.Context) ([]elbv2.LoadBalancer, error) {
	input := &elbv2.DescribeLoadBalancersInput{
		LoadBalancerArns: []*string{},
	}

	result, err := c.elbv2.DescribeLoadBalancers(input)
	if err != nil {
		return nil, errors.Wrap(err, "failed elbv2.DescribeLoadBalancer")
	}

	var unUsedLBs []elbv2.LoadBalancer
	var isUnused bool
	for _, lb := range result.LoadBalancers {
		isUnused = true
		targetGroups, err := c.elbv2.DescribeTargetGroups(&elbv2.DescribeTargetGroupsInput{LoadBalancerArn: lb.LoadBalancerArn})
		if err != nil {
			if aerr, ok := err.(awserr.Error); ok {
				switch aerr.Code() {
				case elbv2.ErrCodeTargetGroupNotFoundException:
					unUsedLBs = append(unUsedLBs, *lb)
					continue
				}
			} else {
				return nil, errors.Wrap(err, "failed elbv2.DescribeTargetGroups")
			}
		}

		for _, targetGroup := range targetGroups.TargetGroups {
			output, err := c.elbv2.DescribeTargetHealth(&elbv2.DescribeTargetHealthInput{TargetGroupArn: targetGroup.TargetGroupArn})
			if err != nil {
				return nil, errors.Wrap(err, "failed elbv2.DescribeTargetHealth")
			}

			for _, target := range output.TargetHealthDescriptions {
				if target.Target.Id != nil {
					isUnused = false
					break // move to next load balancer

				}
			}
		}
		if isUnused {
			unUsedLBs = append(unUsedLBs, *lb)
		}
	}

	return unUsedLBs, nil
}

// DeleteElb it will delete ELB based on ARN
func (c *Client) DeleteElb(context context.Context, loadBalancerArn *string) error {

	_, err := c.elbv2.DeleteLoadBalancer(&elbv2.DeleteLoadBalancerInput{LoadBalancerArn: loadBalancerArn})
	if err != nil {
		return errors.Wrapf(err, "failed elbv2.DeleteLoadBalancer with ARN: %s", *loadBalancerArn)
	}
	return nil
}

// ListUnUsedClassiclb find unused classic LBs
func (c *Client) ListUnUsedClassiclb(context context.Context) ([]*elb.LoadBalancerDescription, error) {
	input := &elb.DescribeLoadBalancersInput{
		LoadBalancerNames: []*string{},
	}
	result, err := c.elb.DescribeLoadBalancers(input)
	if err != nil {
		return nil, errors.Wrap(err, "failed elb.DescribeLoadBalancer")
	}

	var classicLBDescription []*elb.LoadBalancerDescription

	for _, lb := range result.LoadBalancerDescriptions {
		if len(lb.Instances) == 0 {
			classicLBDescription = append(classicLBDescription, lb)
		}
	}
	return classicLBDescription, nil
}

// DeleteClassiclb it will delete the unused classic LB based on LB Name
func (c *Client) DeleteClassiclb(context context.Context, LoadBalancerName *string) error {

	_, err := c.elb.DeleteLoadBalancer(&elb.DeleteLoadBalancerInput{LoadBalancerName: LoadBalancerName})
	if err != nil {
		return errors.Wrapf(err, "failed elb.DeleteLoadBalancer: %s", *LoadBalancerName)
	}
	return nil
}
