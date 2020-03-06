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
	"github.com/opsgenie/opsgenie-go-sdk-v2/alert"
	"github.com/opsgenie/opsgenie-go-sdk-v2/client"
)

type SNSMessageNotification struct {
	AlarmName        string `json:"AlarmName"`
	AlarmDescription string `json:"AlarmDescription,omitempty"`
	AWSAccountID     string `json:"AWSAccountId"`
	NewStateValue    string `json:"NewStateValue"`
	NewStateReason   string `json:"NewStateReason"`
	StateChangeTime  string `json:"StateChangeTime"`
	Region           string `json:"Region"`
	OldStateValue    string `json:"OldStateValue"`
	Trigger          struct {
		MetricName    string `json:"MetricName"`
		Namespace     string `json:"Namespace"`
		StatisticType string `json:"StatisticType"`
		Statistic     string `json:"Statistic"`
		Unit          string `json:"Unit,omitempty"`
		Dimensions    []struct {
			Value string `json:"value"`
			Name  string `json:"name"`
		} `json:"Dimensions"`
		Period                           int     `json:"Period"`
		EvaluationPeriods                int     `json:"EvaluationPeriods"`
		ComparisonOperator               string  `json:"ComparisonOperator"`
		Threshold                        float32 `json:"Threshold"`
		TreatMissingData                 string  `json:"TreatMissingData"`
		EvaluateLowSampleCountPercentile string  `json:"EvaluateLowSampleCountPercentile"`
	} `json:"Trigger"`
}

func main() {
	lambda.Start(handler)
}

func handler(ctx context.Context, snsEvent events.SNSEvent) {
	for _, record := range snsEvent.Records {
		snsRecord := record.SNS

		var messageNotification SNSMessageNotification
		if err := json.Unmarshal([]byte(snsRecord.Message), &messageNotification); err != nil {
			log.WithError(err).Error("Decode Error on message notification")
			return
		}

		sendMattermostNotification(record.EventSource, messageNotification)

		// Trigger OpsGenie
		if os.Getenv("ENVIRONMENT") != "" && os.Getenv("ENVIRONMENT") != "test" {
			if messageNotification.NewStateValue != "OK" {
				sendOpsGenieNotification(messageNotification)
			} else {
				closeOpsGenieAlert(messageNotification)
			}
		}
	}

}

func sendMattermostNotification(source string, messageNotification SNSMessageNotification) {
	attachment := []MMAttachment{}
	attach := MMAttachment{
		Color: "#FF0000",
	}

	if messageNotification.NewStateValue == "OK" {
		attach.Color = "#006400"
	}

	attach = *attach.AddField(MMField{Title: "AlarmName", Value: messageNotification.AlarmName, Short: true})
	attach = *attach.AddField(MMField{Title: "AlarmDescription", Value: messageNotification.AlarmDescription, Short: true})
	attach = *attach.AddField(MMField{Title: "AWS Account", Value: messageNotification.AWSAccountID, Short: true})
	attach = *attach.AddField(MMField{Title: "Region", Value: messageNotification.Region, Short: true})
	attach = *attach.AddField(MMField{Title: "New State", Value: messageNotification.NewStateValue, Short: true})
	attach = *attach.AddField(MMField{Title: "Old State", Value: messageNotification.OldStateValue, Short: true})
	attach = *attach.AddField(MMField{Title: "New State Reason", Value: messageNotification.NewStateReason, Short: false})
	attach = *attach.AddField(MMField{Title: "MetricName", Value: messageNotification.Trigger.MetricName, Short: true})
	attach = *attach.AddField(MMField{Title: "Namespace", Value: messageNotification.Trigger.Namespace, Short: true})

	var dimensions []string
	for _, dimension := range messageNotification.Trigger.Dimensions {
		dimensions = append(dimensions, fmt.Sprintf("%s: %s", dimension.Name, dimension.Value))
	}
	attach = *attach.AddField(MMField{Title: "Dimensions", Value: strings.Join(dimensions, "\n"), Short: false})

	attachment = append(attachment, attach)

	payload := MMSlashResponse{
		Username:    source,
		IconUrl:     "https://cdn2.iconfinder.com/data/icons/amazon-aws-stencils/100/Non-Service_Specific_copy__AWS_Cloud-128.png",
		Attachments: attachment,
	}
	if os.Getenv("MATTERMOST_HOOK") != "" {
		send(os.Getenv("MATTERMOST_HOOK"), payload)
	}
}

func sendOpsGenieNotification(messageNotification SNSMessageNotification) {
	if os.Getenv("OPSGENIE_APIKEY") == "" || os.Getenv("OPSGENIE_SCHEDULER_TEAM") == "" {
		log.Warn("No OpsGenie APIKEY/Scheduler team setup")
		return
	}

	alertClient, err := alert.NewClient(&client.Config{
		ApiKey: os.Getenv("OPSGENIE_APIKEY"),
	})
	if err != nil {
		log.WithError(err).Error("not able to create a new opsgenie client")
		return
	}

	var dimensions []string
	for _, dimension := range messageNotification.Trigger.Dimensions {
		dimensions = append(dimensions, fmt.Sprintf("%s: %s", dimension.Name, dimension.Value))
	}

	_, err = alertClient.Create(nil, &alert.CreateAlertRequest{
		Message:     messageNotification.AlarmName,
		Description: messageNotification.AlarmDescription,
		Responders: []alert.Responder{
			{Type: alert.ScheduleResponder, Name: os.Getenv("OPSGENIE_SCHEDULER_TEAM")},
		},
		Tags: []string{messageNotification.AlarmName, "AWS", "LB"},
		Details: map[string]string{
			"AWS Account": messageNotification.AWSAccountID,
			"Region":      messageNotification.Region,
			"State":       messageNotification.NewStateValue,
			"MetricName":  messageNotification.Trigger.MetricName,
			"NameSpace":   messageNotification.Trigger.Namespace,
			"Dimensions":  strings.Join(dimensions, "\n"),
		},
		Priority: alert.P1,
	})

}

func closeOpsGenieAlert(messageNotification SNSMessageNotification) {
	if os.Getenv("OPSGENIE_APIKEY") == "" {
		log.Warn("No OpsGenie APIKEY setup")
		return
	}

	alertClient, err := alert.NewClient(&client.Config{
		ApiKey: os.Getenv("OPSGENIE_APIKEY"),
	})
	if err != nil {
		log.WithError(err).Error("not able to create a new opsgenie client")
		return
	}

	getResultQuery, err := alertClient.List(nil, &alert.ListAlertRequest{
		Query: fmt.Sprintf("tag:%s", messageNotification.AlarmName),
	})
	if err != nil {
		log.WithError(err).Error("error getting the alterts")
		return
	}

	for _, alarm := range getResultQuery.Alerts {
		_, err = alertClient.Close(nil, &alert.CloseAlertRequest{
			IdentifierType:  alert.ALERTID,
			IdentifierValue: alarm.Id,
		})
		if err != nil {
			log.WithError(err).Errorf("error closing the alert %s", alarm.Id)
			return
		}
	}

}
