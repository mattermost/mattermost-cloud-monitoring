package main

import (
	"context"
	"strconv"
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
	DeleteElbs(context context.Context) ([]string, error)
	DeleteCalssiclbs(context context.Context) ([]string, error)
}

// NewClient factory method to craete AWS client
func NewClient(sess *session.Session) *Client {
	return &Client{
		elbv2: elbv2.New(sess),
		elb:   elb.New(sess),
	}
}

// DeleteElbs it will find & delete any unused network LB
func (c *Client) DeleteElbs(context context.Context) ([]string, error) {
	input := &elbv2.DescribeLoadBalancersInput{
		LoadBalancerArns: []*string{},
	}

	result, err := c.elbv2.DescribeLoadBalancers(input)
	if err != nil {
		return nil, errors.Wrap(err, "failed elbv2.DescribeLoadBalancer")
	}

	var unUsedLBs []string
	var isUnUsed bool
	for _, lb := range result.LoadBalancers {
		isUnUsed = true
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
					isUnUsed = false
					break // move to next load balancer

				}
			}
		}
		if isUnUsed {
			unUsedLBs = append(unUsedLBs, *lb.LoadBalancerArn)
			// c.elbv2.DeleteLoadBalancer(&elbv2.DeleteLoadBalancerInput{LoadBalancerArn: lb.LoadBalancerArn})
		}
	}

	return unUsedLBs, nil
}

// DeleteCalssiclbs find & delete unused LBs
func (c *Client) DeleteCalssiclbs(context context.Context) ([]string, error) {
	input := &elb.DescribeLoadBalancersInput{
		LoadBalancerNames: []*string{},
	}
	result, err := c.elb.DescribeLoadBalancers(input)
	if err != nil {
		return nil, errors.Wrap(err, "failed elb.DescribeLoadBalancer")
	}

	var lb_arns []string

	for _, lb := range result.LoadBalancerDescriptions {
		if len(lb.Instances) == 0 {
			lb_arns = append(lb_arns, *lb.LoadBalancerName+"-"+strconv.Itoa(len(lb.Instances)))
			// c.elb.DeleteLoadBalancer(&elb.DeleteLoadBalancerInput{LoadBalancerName: lb.LoadBalancerName})
		}
	}
	return lb_arns, nil
}
