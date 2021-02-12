package main

import (
	"bytes"
	"encoding/json"
	"net/http"
	"os"

	model "github.com/mattermost/mattermost-server/v5/model"
	"github.com/pkg/errors"
)

func send(webhookURL string, payload model.CommandResponse) error {
	marshalContent, _ := json.Marshal(payload)
	var jsonStr = []byte(marshalContent)
	req, err := http.NewRequest("POST", webhookURL, bytes.NewBuffer(jsonStr))
	req.Header.Set("X-Custom-Header", "aws-sns")
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return errors.Wrap(err, "failed tο send HTTP request")
	}
	defer resp.Body.Close()

	return nil
}

func sendMattermostErrorNotification(errorMessage error, message string) error {
	attachment := &model.SlackAttachment{
		Color: "#FF0000",
		Fields: []*model.SlackAttachmentField{
			{Title: message, Short: false},
			{Title: "Error Message", Value: errorMessage.Error(), Short: false},
		},
	}

	payload := model.CommandResponse{
		Username:    "Account Alerts",
		IconURL:     "https://www.nasa.gov/sites/default/files/thumbnails/image/home02_alerts.jpg",
		Attachments: []*model.SlackAttachment{attachment},
	}
	err := send(os.Getenv("MATTERMOST_ALERTS_HOOK"), payload)
	if err != nil {
		return errors.Wrap(err, "failed tο send Mattermost error payload")
	}

	return nil
}

func sendMattermostAlertNotification(message, resource string) error {
	attachment := &model.SlackAttachment{
		Color: "#FF0000",
		Fields: []*model.SlackAttachmentField{
			{Title: message, Short: false},
			{Title: "Resource", Value: resource, Short: true},
		},
	}

	payload := model.CommandResponse{
		Username:    "Account Alerts",
		IconURL:     "https://www.nasa.gov/sites/default/files/thumbnails/image/home02_alerts.jpg",
		Attachments: []*model.SlackAttachment{attachment},
	}
	err := send(os.Getenv("MATTERMOST_ALERTS_HOOK"), payload)
	if err != nil {
		return errors.Wrap(err, "failed tο send Mattermost error payload")
	}

	return nil
}
