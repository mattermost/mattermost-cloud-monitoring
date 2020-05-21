package main

import (
	"bytes"
	"encoding/json"
	"net/http"
)

// MMField is used for Mattermost attachement creation
type MMField struct {
	Title string `json:"title"`
	Value string `json:"value"`
	Short bool   `json:"short"`
}

// MMAttachment is used to create a Mattermost attachment
type MMAttachment struct {
	Fallback   *string    `json:"fallback"`
	Color      string     `json:"color"`
	PreText    *string    `json:"pretext"`
	AuthorName *string    `json:"author_name"`
	AuthorLink *string    `json:"author_link"`
	AuthorIcon *string    `json:"author_icon"`
	Title      *string    `json:"title"`
	TitleLink  *string    `json:"title_link"`
	Text       *string    `json:"text"`
	ImageURL   *string    `json:"image_url"`
	Fields     []*MMField `json:"fields"`
}

// MMSlashResponse is used to create the payload for the Mattermost notification
type MMSlashResponse struct {
	ResponseType string         `json:"response_type,omitempty"`
	Username     string         `json:"username,omitempty"`
	IconURL      string         `json:"icon_url,omitempty"`
	Channel      string         `json:"channel,omitempty"`
	Text         string         `json:"text,omitempty"`
	GotoLocation string         `json:"goto_location,omitempty"`
	Attachments  []MMAttachment `json:"attachments,omitempty"`
}

// AddField adds a field to a Mattermost attachment
func (attachment *MMAttachment) AddField(field MMField) *MMAttachment {
	attachment.Fields = append(attachment.Fields, &field)
	return attachment
}

func send(webhookURL string, payload MMSlashResponse) {
	marshalContent, _ := json.Marshal(payload)
	var jsonStr = []byte(marshalContent)
	req, err := http.NewRequest("POST", webhookURL, bytes.NewBuffer(jsonStr))
	req.Header.Set("X-Custom-Header", "aws-sns")
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()
}
