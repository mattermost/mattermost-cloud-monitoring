package providers

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/mattermost/mattermost-cloud-monitoring/cloud-manager/pkg/testutils/client_mocks"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"testing"
)

func TestNewAwsProviderWithMissingName(t *testing.T) {
	_, err := NewAwsProvider("", "profile", "region", nil)
	expectedError := "one or all required attributes(name, profile, region) is blank"
	assert.EqualError(t, err, expectedError)
}

func TestNewAwsProviderWithMissingProfile(t *testing.T) {
	_, err := NewAwsProvider("name", "", "region", nil)
	expectedError := "one or all required attributes(name, profile, region) is blank"
	assert.EqualError(t, err, expectedError)
}

func TestNewAwsProviderWithMissingRegion(t *testing.T) {
	_, err := NewAwsProvider("name", "profile", "", nil)
	expectedError := "one or all required attributes(name, profile, region) is blank"
	assert.EqualError(t, err, expectedError)
}

func TestNewAwsProvider(t *testing.T) {
	errorConfiguration := make(map[string]bool)
	emptyConfiguration := make(map[string]bool)

	mockClient := &client_mocks.MockEC2Client{
		WithErrors:       errorConfiguration,
		RecordInput:      false,
		WithEmptyResults: emptyConfiguration,
	}
	_, err := NewAwsProvider("aws", "profile", "region", mockClient)
	require.NoError(t, err, "creating new aws provider should not error")
}

func TestGetName(t *testing.T) {
	errorConfiguration := make(map[string]bool)
	emptyConfiguration := make(map[string]bool)

	mockClient := &client_mocks.MockEC2Client{
		WithErrors:       errorConfiguration,
		RecordInput:      false,
		WithEmptyResults: emptyConfiguration,
	}
	provider, err := NewAwsProvider("aws", "profile", "region", mockClient)
	require.NoError(t, err, "creating new aws provider should not error")
	assert.Equal(t, "aws", provider.GetName())
}

func TestGetInstance(t *testing.T) {
	errorConfiguration := make(map[string]bool)
	emptyConfiguration := make(map[string]bool)

	mockClient := &client_mocks.MockEC2Client{
		WithErrors:       errorConfiguration,
		RecordInput:      true,
		WithEmptyResults: emptyConfiguration,
	}

	provider, err := NewAwsProvider("aws", "profile", "region", mockClient)
	require.NoError(t, err, "creating new aws provider should not error")
	instance, err := provider.GetInstance("test")
	require.NoError(t, err, "fetching instance should not error")
	require.NotNil(t, instance)
	assert.EqualValues(t, aws.String("test-instance"), instance.InstanceId)
	inputs := mockClient.GetInputs()["DescribeInstance"]
	assert.Equal(t, 1, len(inputs))
	expectedInput := &ec2.DescribeInstancesInput{
		Filters: []*ec2.Filter{
			{
				Name:   aws.String("private-dns-name"),
				Values: aws.StringSlice([]string{"test"}),
			},
		},
	}
	assert.EqualValues(t, expectedInput, inputs[0])
}

func TestGetInstanceWithEmptyResults(t *testing.T) {
	errorConfiguration := make(map[string]bool)
	emptyConfiguration := make(map[string]bool)
	emptyConfiguration["DescribeInstances"] = true

	mockClient := &client_mocks.MockEC2Client{
		WithErrors:       errorConfiguration,
		RecordInput:      false,
		WithEmptyResults: emptyConfiguration,
	}

	provider, err := NewAwsProvider("aws", "profile", "region", mockClient)
	require.NoError(t, err, "creating new aws provider should not error")
	instance, err := provider.GetInstance("test")
	require.NoError(t, err, "fetching instance should not error")
	assert.Nil(t, instance)
}

func TestGetInstanceWhenEc2Errors(t *testing.T) {
	errorConfiguration := make(map[string]bool)
	emptyConfiguration := make(map[string]bool)
	errorConfiguration["DescribeInstances"] = true
	mockClient := &client_mocks.MockEC2Client{
		WithErrors:       errorConfiguration,
		RecordInput:      false,
		WithEmptyResults: emptyConfiguration,
	}

	provider, err := NewAwsProvider("aws", "profile", "region", mockClient)
	require.NoError(t, err, "creating new aws provider should not error")
	_, getInstanceErr := provider.GetInstance("test")
	assert.EqualError(t, getInstanceErr, "Failed to fetch DescribeInstances")
}

func TestTerminateInstanceWhenGetInstanceFails(t *testing.T) {
	errorConfiguration := make(map[string]bool)
	emptyConfiguration := make(map[string]bool)
	errorConfiguration["DescribeInstances"] = true
	mockClient := &client_mocks.MockEC2Client{
		WithErrors:       errorConfiguration,
		RecordInput:      false,
		WithEmptyResults: emptyConfiguration,
		InstanceState:    "pending",
	}

	provider, err := NewAwsProvider("aws", "profile", "region", mockClient)
	require.NoError(t, err, "creating new aws provider should not error")
	_, terminateInstanceError := provider.TerminateInstance("test")
	assert.EqualError(t, terminateInstanceError, "Failed to fetch DescribeInstances")
}

func TestTerminateInstanceWhenInstanceNotFound(t *testing.T) {
	errorConfiguration := make(map[string]bool)
	emptyConfiguration := make(map[string]bool)
	emptyConfiguration["DescribeInstances"] = true

	mockClient := &client_mocks.MockEC2Client{
		WithErrors:       errorConfiguration,
		RecordInput:      false,
		WithEmptyResults: emptyConfiguration,
	}

	provider, err := NewAwsProvider("aws", "profile", "region", mockClient)
	require.NoError(t, err, "creating new aws provider should not error")
	isTerminated, err := provider.TerminateInstance("test")
	require.NoError(t, err, "terminate instance should not fail")
	assert.False(t, isTerminated, "should not terminate a non existent instance")
}

func TestTerminateInstanceWhenTerminatedInstancesAreEmpty(t *testing.T) {
	errorConfiguration := make(map[string]bool)
	emptyConfiguration := make(map[string]bool)
	emptyConfiguration["TerminateInstances"] = true

	mockClient := &client_mocks.MockEC2Client{
		WithErrors:       errorConfiguration,
		RecordInput:      false,
		WithEmptyResults: emptyConfiguration,
	}

	provider, err := NewAwsProvider("aws", "profile", "region", mockClient)
	require.NoError(t, err, "creating new aws provider should not error")
	isTerminated, err := provider.TerminateInstance("test")
	require.NoError(t, err, "terminate instance should not fail")
	assert.False(t, isTerminated, "should not terminate a non existent instance")
}

func TestTerminateInstanceWhenTerminatedInstancesStateIsNotShuttingDown(t *testing.T) {
	errorConfiguration := make(map[string]bool)
	emptyConfiguration := make(map[string]bool)

	mockClient := &client_mocks.MockEC2Client{
		WithErrors:       errorConfiguration,
		RecordInput:      false,
		WithEmptyResults: emptyConfiguration,
		InstanceState:    "running",
	}

	provider, err := NewAwsProvider("aws", "profile", "region", mockClient)
	require.NoError(t, err, "creating new aws provider should not error")
	isTerminated, err := provider.TerminateInstance("test")
	require.NoError(t, err, "terminate instance should not fail")
	assert.False(t, isTerminated, "should return false when instance state is not shutting-down")
}

func TestTerminateInstanceWhenTerminatedInstances(t *testing.T) {
	errorConfiguration := make(map[string]bool)
	emptyConfiguration := make(map[string]bool)

	mockClient := &client_mocks.MockEC2Client{
		WithErrors:       errorConfiguration,
		RecordInput:      false,
		WithEmptyResults: emptyConfiguration,
		InstanceState:    "shutting-down",
	}

	provider, err := NewAwsProvider("aws", "profile", "region", mockClient)
	require.NoError(t, err, "creating new aws provider should not error")
	isTerminated, err := provider.TerminateInstance("test")
	require.NoError(t, err, "terminate instance should not fail")
	assert.True(t, isTerminated, "should return true when instance state is shutting-down")
}
