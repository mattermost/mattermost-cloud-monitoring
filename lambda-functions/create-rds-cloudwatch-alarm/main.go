package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"strings"

	log "github.com/sirupsen/logrus"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/cloudwatch"
	"github.com/aws/aws-sdk-go/service/rds"
)

type Detail struct {
	UserIdentity      UserIdentity      `json:"userIdentity"`
	EventSource       string            `json:"eventSource"`
	EventName         string            `json:"eventName"`
	AwsRegion         string            `json:"awsRegion"`
	RequestParameters RequestParameters `json:"requestParameters"`
	ResponseElements  ResponseElements  `json:"responseElements"`
}

type UserIdentity struct {
	Arn       string `json:"arn"`
	AccountID string `json:"accountId"`
	InvokedBy string `json:"invokedBy"`
}

type RequestParameters struct {
	DBClusterIdentifier string `json:"dBClusterIdentifier"`
}

type ResponseElements struct {
	DBClusterIdentifier string `json:"dBClusterIdentifier"`
}

func main() {
	lambda.Start(handler)
}

func handler(ctx context.Context, event events.CloudWatchEvent) {
	log.Infof("Detail = %s\n", event.Detail)

	if event.Source == "aws.rds" {
		var eventDetail Detail
		err := json.Unmarshal(event.Detail, &eventDetail)
		if err != nil {
			log.WithError(err).Errorln("Error decoding the Event detail")
			return
		}
		log.Infof("eventDetail = %+v\n", eventDetail)

		switch eventDetail.EventName {
		case "CreateDBInstance":
			err := createCloudWatchAlarm(eventDetail.RequestParameters.DBClusterIdentifier)
			if err != nil {
				log.WithError(err).Errorln("Error creating the CloudWatch Alarm")
				return
			}
		case "DeleteDBInstance":
			err = deleteCloudWatchAlarm(eventDetail.ResponseElements.DBClusterIdentifier)
			if err != nil {
				log.WithError(err).Errorln("Error deleting the CloudWatch Alarm")
				return
			}
		default:
			log.Infof("Event did not match. Event = %s", eventDetail.EventName)
		}

		return
	}
	// Trigger manually to go over all RDS and create missing CloudWatchAlarms
	listRDS()
}

func createCloudWatchAlarm(dbClusterName string) error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		log.WithError(err).Errorln("Error creating aws session")
		return err
	}

	newMetricAlarm := &cloudwatch.PutMetricAlarmInput{
		ActionsEnabled:     aws.Bool(true),
		MetricName:         aws.String("DatabaseConnections"),
		AlarmName:          aws.String(fmt.Sprintf("Alarm-RDS-%s", dbClusterName)),
		ComparisonOperator: aws.String(cloudwatch.ComparisonOperatorLessThanOrEqualToThreshold),
		EvaluationPeriods:  aws.Int64(1),
		Period:             aws.Int64(900),
		Statistic:          aws.String(cloudwatch.StatisticAverage),
		Threshold:          aws.Float64(0),
		AlarmDescription:   aws.String("Alarm when having no DB connections"),
		Namespace:          aws.String("AWS/RDS"),
		Dimensions: []*cloudwatch.Dimension{
			{
				Name:  aws.String("DBClusterIdentifier"),
				Value: aws.String(dbClusterName),
			},
		},
		AlarmActions: []*string{
			aws.String(os.Getenv("SNS_TOPIC")),
		},
		OKActions: []*string{
			aws.String(os.Getenv("SNS_TOPIC")),
		},
	}

	svc := cloudwatch.New(sess)
	_, err = svc.PutMetricAlarm(newMetricAlarm)
	if err != nil {
		log.WithError(err).Errorln("Error creating aws cloudwatch alarm")
		return err
	}

	return nil
}

func deleteCloudWatchAlarm(dbClusterName string) error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		log.WithError(err).Errorln("Error creating aws session")
		return err
	}

	svc := cloudwatch.New(sess)
	_, err = svc.DeleteAlarms(&cloudwatch.DeleteAlarmsInput{
		AlarmNames: []*string{aws.String(fmt.Sprintf("Alarm-RDS-%s", dbClusterName))},
	})
	if err != nil {
		log.WithError(err).Errorln("Error deleting aws cloudwatch alarm")
		return err
	}

	return nil
}

func listRDS() error {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		log.WithError(err).Errorln("Error creating aws session")
		return err
	}

	svc := rds.New(sess)
	input := &rds.DescribeDBClustersInput{}

	result, err := svc.DescribeDBClusters(input)
	if err != nil {
		return err
	}

	for _, dbCluster := range result.DBClusters {
		// filtering the rds multitenant
		if !strings.Contains(*dbCluster.DBClusterIdentifier, "rds-cluster-multitenant-") {
			log.Infof("Creating CloudWatch Alarm for %+v\n", *dbCluster.DBClusterIdentifier)
			err = createCloudWatchAlarm(*dbCluster.DBClusterIdentifier)
			if err != nil {
				return nil
			}
		}
	}

	return nil
}
