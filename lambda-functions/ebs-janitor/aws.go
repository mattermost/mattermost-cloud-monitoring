package main

import (
	"context"
	"fmt"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/pkg/errors"
)

// awsTimeout used for the context of AWS SDK
const awsTimeout = 20 * time.Second

// Client for making AWS requests
type Client struct {
	ec2 *ec2.EC2
}

// Resourcer the interface for the AWS client
type Resourcer interface {
	ListVolumes(context context.Context, volumeState string) ([]*ec2.Volume, error)
	DeleteVolume(context context.Context, volumeID *string) error
}

// NewClient factory method to craete AWS client
func NewClient(sess *session.Session) *Client {
	return &Client{
		ec2: ec2.New(sess),
	}
}

// ListEBS listing ebs for deletion
func (c *Client) ListVolumes(context context.Context, volumeState string) ([]*ec2.Volume, error) {
	if !contains(ec2.VolumeState_Values(), volumeState) {
		return []*ec2.Volume{}, fmt.Errorf("failed: wrong volume state value, %s", volumeState)
	}
	out, err := c.ec2.DescribeVolumesWithContext(context, &ec2.DescribeVolumesInput{
		Filters: []*ec2.Filter{
			{
				Name: aws.String("status"),
				Values: []*string{
					aws.String(volumeState),
				},
			},
		},
	})
	if err != nil {
		return []*ec2.Volume{}, errors.Wrap(err, "failed ec2.DescribeVolumes")
	}
	return out.Volumes, nil
}

// DeleteVolume deletes a volume by the provided volume ID
func (c *Client) DeleteVolume(context context.Context, volumeID *string) error {
	_, err := c.ec2.DeleteVolumeWithContext(context, &ec2.DeleteVolumeInput{
		VolumeId: volumeID,
	})
	if err != nil {
		return errors.Wrapf(err, "failed ec2.DeleteVolume with ID: %s", *volumeID)
	}
	return nil
}

func contains(s []string, e string) bool {
	for _, a := range s {
		if a == e {
			return true
		}
	}
	return false
}
