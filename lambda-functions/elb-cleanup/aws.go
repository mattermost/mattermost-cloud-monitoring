package main

import (
	"context"
	"time"

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
	ListUnusedElbs(context context.Context) ([]elbv2.LoadBalancer, error)
	DeleteElbs(context context.Context, unUsedLBs []elbv2.LoadBalancer) error
	ListUnUsedClassiclbs(context context.Context) ([]*elb.LoadBalancerDescription, error)
	DeleteClassiclbs(context context.Context, elbDescList []*elb.LoadBalancerDescription) error
}

// NewClient factory method to create AWS client
func NewClient(sess *session.Session) *Client {
	return &Client{
		elbv2: elbv2.New(sess),
		elb:   elb.New(sess),
	}
}

// ListUnusedElbs it will find any unused network LB
func (c *Client) ListUnusedElbs(context context.Context) ([]elbv2.LoadBalancer, error) {
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
			return nil, errors.Wrap(err, "failed elbv2.DescribeTargetGroups")
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

// DeleteElbs it will find & delete any unused network LB
func (c *Client) DeleteElbs(context context.Context, unUsedLBs []elbv2.LoadBalancer) error {

	for _, unUsedLB := range unUsedLBs {
		_, err := c.elbv2.DeleteLoadBalancer(&elbv2.DeleteLoadBalancerInput{LoadBalancerArn: unUsedLB.LoadBalancerArn})
		if err != nil {
			return errors.Wrapf(err, "failed elbv2.DeleteLoadBalancer with ID: %s", unUsedLB)
		}
	}
	return nil
}

// ListUnUsedClassiclbs find unused classic LBs
func (c *Client) ListUnUsedClassiclbs(context context.Context) ([]*elb.LoadBalancerDescription, error) {
	input := &elb.DescribeLoadBalancersInput{
		LoadBalancerNames: []*string{},
	}
	result, err := c.elb.DescribeLoadBalancers(input)
	if err != nil {
		return nil, errors.Wrap(err, "failed elb.DescribeLoadBalancer")
	}

	return result.LoadBalancerDescriptions, nil
}

// DeleteClassiclbs find & delete unused LBs
func (c *Client) DeleteClassiclbs(context context.Context, elbDescList []*elb.LoadBalancerDescription) error {

	for _, lb := range elbDescList {
		_, err := c.elb.DeleteLoadBalancer(&elb.DeleteLoadBalancerInput{LoadBalancerName: lb.LoadBalancerName})
		if err != nil {
			return errors.Wrapf(err, "failed elb.DeleteLoadBalancer with ID: %s", *lb.LoadBalancerName)
		}
	}
	return nil
}
