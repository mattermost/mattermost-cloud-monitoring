package main

import (
	"testing"
	"fmt"
	"github.com/aws/aws-sdk-go/service/route53"
)

func TestGetUsername(t *testing.T) {
	tests := []struct {
		name       string
		iamRoleARN string
		answer     string
	}{
		{
			"nonroot arn",
			"arn:aws:iam::868251936258:role/test-role-name",
			"test-role-name",
		},
		{
			"root arn",
			"arn:aws:iam::868251936258:role/service/test-role-name",
			"test-role-name",
		},
		{
			"root arn",
			"arn:aws:iam::868251936258:test-user",
			"iam-root-account",
		},
	}

	for _, tt := range tests {
		iamRole := getUsername(tt.iamRoleARN)
		if iamRole != tt.answer {
			t.Errorf("Return username different from expected answer. Expected: %s, Got: %s.", iamRole, tt.answer)
		}
	}
}

func TestDecodeConfig(t *testing.T) {
	testValue := "test.mattermost.com"
	data := fmt.Sprintf("scrape_configs:\n - static_configs:\n   - targets: [%s]\n", testValue)
	C := config{}
	C, err := decodeConfig(data, C)
	if err != nil {
		t.Error(err)
	}

	if C.ScrapeConfigs[0].StaticConfigs[0].Targets[0] != testValue {
		t.Errorf("Test value is different from decoded value. Expected: %s, Got: %s.", testValue, C.ScrapeConfigs[0].StaticConfigs[0].Targets)
	}
}
