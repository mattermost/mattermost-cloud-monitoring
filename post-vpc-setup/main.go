package main

import (
	"context"
	"encoding/json"
	"os"
	"time"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/cloudtrail"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/pkg/errors"

	log "github.com/sirupsen/logrus"
)

const (
	transitGatewayEnv = "TRANSIT_GATEWAY_ID"
)

// CreateVPCEvent extends the CloudTrail event to be specific to the CreateVPC event
type CreateVPCEvent struct {
	cloudtrail.Event

	ResponseElements struct {
		RequestID string `json:"requestId"`
		VPC       struct {
			ID                      string `json:"vpcId"`
			State                   string `json:"state"`
			OwnerID                 string `json:"ownerId"`
			CidrBlock               string `json:"cidrBlock"`
			CidrBlockAssociationSet struct {
				Items []struct {
					CidrBlock      string `json:"cidrBlock"`
					AssociationID  string `json:"associationId"`
					CidrBlockState struct {
						State string `json:"state"`
					} `json:"cidrBlockState"`
				} `json:"items"`
			} `json:"cidrBlockAssociationSet"`
			Ipv6CidrBlockAssociationSet struct {
			} `json:"ipv6CidrBlockAssociationSet"`
			DhcpOptionsID   string `json:"dhcpOptionsId"`
			InstanceTenancy string `json:"instanceTenancy"`
			TagSet          struct {
			} `json:"tagSet"`
			IsDefault bool `json:"isDefault"`
		} `json:"vpc"`
	} `json:"responseElements"`
}

func postVPCCreation(ctx context.Context, cloudWatchEvent events.CloudWatchEvent) {
	transitGatewayID := os.Getenv(transitGatewayEnv)
	if len(transitGatewayID) == 0 {
		log.Fatal(transitGatewayEnv + " environment variable is not set.")
		return
	}

	event := &CreateVPCEvent{}
	err := json.Unmarshal(cloudWatchEvent.Detail, event)
	if err != nil {
		log.WithError(err).Fatal("Unable to unmarshal event details")
	}

	log.Infof("New VPC created with id: %s", event.ResponseElements.VPC.ID)

	err = attachToTransitGateway(event.ResponseElements.VPC.ID, transitGatewayID)
	if err != nil {
		log.WithError(err).Fatal("Unable to create transit gateway attachment")
	}

}

func attachToTransitGateway(vpcID, transitGatewayID string) error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return err
	}

	svc := ec2.New(sess)

	subnetInput := &ec2.DescribeSubnetsInput{
		Filters: []*ec2.Filter{
			{
				Name: aws.String("vpc-id"),
				Values: []*string{
					aws.String(vpcID),
				},
			},
		},
	}

	subnetResults, err := svc.DescribeSubnets(subnetInput)
	if err != nil {
		return err
	}

	if len(subnetResults.Subnets) == 0 {
		wait := 120
		log.Infof("Waiting up to %d seconds for Subnets to get created...", wait)
		ctx, cancel := context.WithTimeout(context.Background(), time.Duration(wait)*time.Second)
		defer cancel()
		for {
			subnetResults, err = svc.DescribeSubnets(subnetInput)
			if err != nil {
				return err
			}
			if len(subnetResults.Subnets) != 0 {
				log.Infof("Subnets created in VPC - %s", vpcID)
				break
			}
			select {
			case <-ctx.Done():
				return errors.Wrap(ctx.Err(), "timed out waiting for Subnets to get created")
			case <-time.After(10 * time.Second):
			}
		}
	}

	subnetIDs := make([]*string, len(subnetResults.Subnets))
	for i, subnet := range subnetResults.Subnets {
		subnetIDs[i] = subnet.SubnetId
	}

	log.Infof("Subnets to attach: %v", subnetIDs)

	attachmentInput := &ec2.CreateTransitGatewayVpcAttachmentInput{
		VpcId:            aws.String(vpcID),
		SubnetIds:        subnetIDs,
		TransitGatewayId: aws.String(transitGatewayID),
	}

	_, err = svc.CreateTransitGatewayVpcAttachment(attachmentInput)
	if err != nil {
		return errors.Wrap(err, "error attaching VPC to transit gateway")
	}

	return nil
}

// func dettachFromTransitGateway(vpcID, transitGatewayID string) error {}

// func addRouteTableRecord{}

// func enableVPCFlowLogs{}

func main() {
	lambda.Start(postVPCCreation)
}
