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
	SourceID     string `json:"Source ID"`
	EventMessage string `json:"Event Message"`
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

		if strings.HasPrefix(messageNotification.EventMessage, "Started cross AZ failover") {
			sendMattermostNotification(record.EventSource, "#FF0000", messageNotification)

			// Trigger OpsGenie
			if os.Getenv("ENVIRONMENT") != "" && os.Getenv("ENVIRONMENT") != "test" {
				sendOpsGenieNotification(messageNotification)
			}
		} else if strings.HasPrefix(messageNotification.EventMessage, "Completed failover") {
			sendMattermostNotification(record.EventSource, "#006400", messageNotification)

			// Trigger OpsGenie
			if os.Getenv("ENVIRONMENT") != "" && os.Getenv("ENVIRONMENT") != "test" {
				closeOpsGenieAlert(messageNotification)
			}
		}
	}
}

func sendMattermostNotification(source, color string, messageNotification SNSMessageNotification) {
	attachment := []MMAttachment{}
	attach := MMAttachment{
		Color: color,
	}
	attach = *attach.AddField(MMField{Title: "RDS DB Cluster Failover", Short: false})
	attach = *attach.AddField(MMField{Title: "Cluster", Value: messageNotification.SourceID, Short: true})
	attach = *attach.AddField(MMField{Title: "Message", Value: messageNotification.EventMessage, Short: true})

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

	_, err = alertClient.Create(nil, &alert.CreateAlertRequest{
		Message:     messageNotification.EventMessage,
		Description: messageNotification.EventMessage,
		Responders: []alert.Responder{
			{Type: alert.ScheduleResponder, Name: os.Getenv("OPSGENIE_SCHEDULER_TEAM")},
		},
		Tags: []string{"AWS", "RDS"},
		Details: map[string]string{
			"Cluster": messageNotification.SourceID,
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
		Query: fmt.Sprintf("tag:%s", messageNotification.EventMessage),
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
