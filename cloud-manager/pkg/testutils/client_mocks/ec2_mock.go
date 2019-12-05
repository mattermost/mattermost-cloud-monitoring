package client_mocks

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/aws/aws-sdk-go/service/ec2/ec2iface"
	"github.com/pkg/errors"
)

type MockEC2Client struct {
	ec2iface.EC2API
	WithErrors       map[string]bool
	RecordInput      bool
	inputs           map[string][]interface{}
	WithEmptyResults map[string]bool
	InstanceState    string
}

func (m *MockEC2Client) DescribeInstances(input *ec2.DescribeInstancesInput) (*ec2.DescribeInstancesOutput, error) {
	if len(m.inputs) == 0 {
		m.inputs = make(map[string][]interface{})
	}

	if m.RecordInput {
		currentInputs := m.inputs["DescribeInstance"]
		currentInputs = append(currentInputs, input)
		m.inputs["DescribeInstance"] = currentInputs
	}

	if m.WithErrors["DescribeInstances"] {
		return nil, errors.New("Failed to fetch DescribeInstances")
	}

	var reservations []*ec2.Reservation

	if m.WithEmptyResults["DescribeInstances"] {
		reservations = []*ec2.Reservation{}
	} else {
		instance := &ec2.Instance{InstanceId: aws.String("test-instance")}
		instances := []*ec2.Instance{instance}
		reservation := &ec2.Reservation{Instances: instances}
		reservations = []*ec2.Reservation{reservation}
	}

	return &ec2.DescribeInstancesOutput{
		Reservations: reservations,
	}, nil
}

func (m *MockEC2Client) TerminateInstances(input *ec2.TerminateInstancesInput) (*ec2.TerminateInstancesOutput, error) {
	if len(m.inputs) == 0 {
		m.inputs = make(map[string][]interface{})
	}

	if m.RecordInput {
		currentInputs := m.inputs["TerminateInstances"]
		currentInputs = append(currentInputs, input)
		m.inputs["TerminateInstances"] = currentInputs
	}

	if m.WithErrors["TerminateInstances"] {
		return nil, errors.New("Failed to terminate instances")
	}

	var terminatedInstances []*ec2.InstanceStateChange

	if m.WithEmptyResults["TerminateInstances"] {
		terminatedInstances = []*ec2.InstanceStateChange{}
	} else {
		currentState := &ec2.InstanceState{Name: aws.String(m.InstanceState)}
		instanceStateChange := &ec2.InstanceStateChange{CurrentState: currentState}
		terminatedInstances = []*ec2.InstanceStateChange{instanceStateChange}
	}

	return &ec2.TerminateInstancesOutput{
		TerminatingInstances: terminatedInstances,
	}, nil
}

func (m *MockEC2Client) GetInputs() map[string][]interface{} {
	return m.inputs
}
