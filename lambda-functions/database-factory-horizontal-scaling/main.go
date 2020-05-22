package main

import (
	"bytes"
	"encoding/json"
	"io/ioutil"
	"net/http"
	"os"
	"strconv"
	"strings"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/arn"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/aws/aws-sdk-go/service/resourcegroupstaggingapi"
	"github.com/pkg/errors"

	log "github.com/sirupsen/logrus"
)

// DatabaseFactoryRequest is used to unmarshal database factory request that will be used for Mattermost notifications
type DatabaseFactoryRequest struct {
	VPCID                 string `json:"vpcID"`
	Environment           string `json:"environment"`
	StateStore            string `json:"stateStore"`
	Apply                 bool   `json:"apply"`
	InstanceType          string `json:"instanceType"`
	BackupRetentionPeriod string `json:"backupRetentionPeriod"`
	ClusterID             string `json:"clusterID"`
}

func main() {
	lambda.Start(handler)
}

func handler() {
	err := checkEnvVariables()
	if err != nil {
		log.WithError(err).Error("Environment variables were not set")
		err = sendMattermostErrorNotification(err, "The Database Factory horizontal scaling Lambda failed.")
		if err != nil {
			log.WithError(err).Error("Failed to send Mattermost error notification")
		}
		return
	}
	vpcList, err := getVPCs()
	if err != nil {
		log.WithError(err).Error("Unable to get VPCs")
		err = sendMattermostErrorNotification(err, "The Database Factory horizontal scaling Lambda failed.")
		if err != nil {
			log.WithError(err).Error("Failed to send Mattermost error notification")
		}
		return
	}
	_, err = checkDBClustersScaling(vpcList)
	if err != nil {
		log.WithError(err).Error("Unable to check DB cluster scaling")
		err = sendMattermostErrorNotification(err, "The Database Factory horizontal scaling Lambda failed.")
		if err != nil {
			log.WithError(err).Error("Failed to send Mattermost error notification")
		}
		return
	}
}

func checkEnvVariables() error {
	var envVariables = []string{
		"RDSMultitenantDBClusterNamePrefix",
		"RDSMultitenantDBClusterTagPurpose",
		"RDSMultitenantDBClusterTagDatabaseType",
		"MaxAllowedInstallations",
		"Environment",
		"DBInstanceType",
		"TerraformApply",
		"BackupRetentionPeriod",
		"DatabaseFactoryEndpoint",
		"MattermostNotificationsHook",
		"MattermostAlertsHook",
		"StateStore",
	}

	for _, envVar := range envVariables {
		if os.Getenv(envVar) == "" {
			return errors.Errorf("Environment variable %s was not set", envVar)
		}
	}

	_, err := strconv.ParseBool(os.Getenv("TerraformApply"))
	if err != nil {
		return errors.Wrap(err, "failed to parse bool from TerraformApply string")
	}
	_, err = strconv.Atoi(os.Getenv("MaxAllowedInstallations"))
	if err != nil {
		return errors.Wrap(err, "failed to parse integer from CounterLimit string")
	}
	return nil
}

func getVPCs() ([]string, error) {
	var next *string
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return nil, errors.Wrapf(err, "Unable to get initiate AWS session")
	}

	client := ec2.New(sess)
	filter := []*ec2.Filter{
		{
			Name:   aws.String("tag:Purpose"),
			Values: []*string{aws.String("provisioning")},
		},
		{
			Name:   aws.String("tag:Terraform"),
			Values: []*string{aws.String("true")},
		},
		{
			Name:   aws.String("tag:Available"),
			Values: []*string{aws.String("false")},
		},
	}
	var vpcList []string
	for {
		vpcs, err := client.DescribeVpcs(&ec2.DescribeVpcsInput{Filters: filter, NextToken: next})
		if err != nil {
			return nil, errors.Wrapf(err, "Unable to get Provisioning VPCs")
		}

		for _, vpc := range vpcs.Vpcs {
			vpcList = append(vpcList, *vpc.VpcId)
		}

		if vpcs.NextToken == nil || *vpcs.NextToken == "" {
			break
		}

		next = vpcs.NextToken

	}
	if len(vpcList) == 0 {
		return nil, errors.Errorf("VPC describe returned an empty list")
	}
	return vpcList, nil

}

func checkDBClustersScaling(vpcList []string) ([]string, error) {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return nil, errors.Wrapf(err, "Unable to get initiate AWS session")
	}
	client := resourcegroupstaggingapi.New(sess)

	for _, vpc := range vpcList {
		log.Infof("Checking DB clusters for VPC (%s)", vpc)
		dbClusters, err := client.GetResources(&resourcegroupstaggingapi.GetResourcesInput{
			TagFilters: []*resourcegroupstaggingapi.TagFilter{
				{
					Key:    aws.String("DatabaseType"),
					Values: []*string{aws.String(os.Getenv("RDSMultitenantDBClusterTagDatabaseType"))},
				},
				{
					Key:    aws.String("VpcID"),
					Values: []*string{aws.String(vpc)},
				},
				{
					Key:    aws.String("Purpose"),
					Values: []*string{aws.String(os.Getenv("RDSMultitenantDBClusterTagPurpose"))},
				},
			},
			ResourceTypeFilters: []*string{aws.String("rds:cluster")},
		})
		if err != nil {
			return nil, errors.Wrap(err, "failed to get available multitenant DB clusters")
		}
		if len(dbClusters.ResourceTagMappingList) > 0 {
			needsScaling, err := checkVPCScaling(dbClusters, vpc)
			if err != nil {
				return nil, errors.Wrap(err, "failed to check if cluster scaling is needed")
			}
			if needsScaling {
				log.Infof("Initiating new RDS cluster deployment in vpc (%s)", vpc)
				err = requestDeployCluster(vpc)
				if err != nil {
					return nil, errors.Wrap(err, "failed to request a new RDS cluster deployment")
				}
			}
		}

	}

	return nil, nil
}

func requestDeployCluster(vpc string) error {
	applyBool, _ := strconv.ParseBool(os.Getenv("TerraformApply"))

	requestBody, err := json.Marshal(map[string]interface{}{
		"vpcID":                 vpc,
		"environment":           os.Getenv("Environment"),
		"stateStore":            os.Getenv("StateStore"),
		"apply":                 applyBool,
		"instanceType":          os.Getenv("DBInstanceType"),
		"backupRetentionPeriod": os.Getenv("BackupRetentionPeriod"),
	})
	if err != nil {
		return errors.Wrap(err, "failed to marshal request body")
	}

	resp, err := http.Post(os.Getenv("DatabaseFactoryEndpoint"), "application/json", bytes.NewBuffer(requestBody))
	if err != nil {
		return errors.Wrap(err, "failed to POST request")
	}

	defer resp.Body.Close()
	statusOK := resp.StatusCode >= 200 && resp.StatusCode < 300
	if !statusOK {
		return errors.Errorf("Non-OK HTTP status:%v", resp.StatusCode)
	}
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return errors.Wrap(err, "failed tο read response body")
	}
	var databaseFactoryRequest DatabaseFactoryRequest
	err = json.Unmarshal(body, &databaseFactoryRequest)
	if err != nil {
		return errors.Wrap(err, "failed tο unmarshal database factory request")
	}
	err = sendMattermostNotification(databaseFactoryRequest, "A new RDS Cluster was successfully requested in the Database Factory.")
	if err != nil {
		return errors.Wrap(err, "failed tο send Mattermost notification")
	}
	log.Infof("The request was posted successfully %s", string(body))

	return nil
}

func checkVPCScaling(dbClusters *resourcegroupstaggingapi.GetResourcesOutput, vpc string) (bool, error) {
	var deployedClusters int
	var clustersOverLimit int
	maxAllowedInstallations, _ := strconv.Atoi(os.Getenv("MaxAllowedInstallations"))

	for _, cluster := range dbClusters.ResourceTagMappingList {
		var counter *string
		clusterARN, err := arn.Parse(*cluster.ResourceARN)
		if err != nil {
			return false, errors.Wrap(err, "failed tο parse DB cluster ARN")
		}
		if !strings.Contains(clusterARN.Resource, os.Getenv("RDSMultitenantDBClusterNamePrefix")) {
			log.Warnf("Provisioner skipped RDS resource (%s) because name does not have a correct multitenant database prefix (%s)", clusterARN.Resource, os.Getenv("RDSMultitenantDBClusterNamePrefix"))
			continue
		}
		deployedClusters++
		for _, tag := range cluster.Tags {
			if *tag.Key == "Counter" && tag.Value != nil {
				counter = tag.Value
			}
		}
		currentDeployedInstallations, err := strconv.Atoi(*counter)
		if err != nil {
			return false, errors.Wrap(err, "failed tο change tag counter value into integer")
		}
		if currentDeployedInstallations >= maxAllowedInstallations {
			clustersOverLimit++
		}
	}
	if deployedClusters == clustersOverLimit {
		log.Infof("The VPC (%s) has %d deployed RDS Clusters and scaling is needed", vpc, deployedClusters)
		return true, nil
	}
	log.Infof("The VPC (%s) has %d deployed RDS Clusters and no scaling is needed", vpc, deployedClusters)
	return false, nil
}

func sendMattermostNotification(databaseFactoryRequest DatabaseFactoryRequest, message string) error {
	attachment := []MMAttachment{}
	attach := MMAttachment{
		Color: "#006400",
	}

	attach = *attach.AddField(MMField{Title: message, Short: false}).
		AddField(MMField{Title: "VPCID", Value: databaseFactoryRequest.VPCID, Short: true}).
		AddField(MMField{Title: "Environment", Value: databaseFactoryRequest.Environment, Short: true}).
		AddField(MMField{Title: "StateStore", Value: databaseFactoryRequest.StateStore, Short: true}).
		AddField(MMField{Title: "Apply", Value: strconv.FormatBool(databaseFactoryRequest.Apply), Short: true}).
		AddField(MMField{Title: "InstanceType", Value: databaseFactoryRequest.InstanceType, Short: true}).
		AddField(MMField{Title: "BackupRetentionPeriod", Value: databaseFactoryRequest.BackupRetentionPeriod, Short: true}).
		AddField(MMField{Title: "ClusterID", Value: databaseFactoryRequest.ClusterID, Short: true})

	attachment = append(attachment, attach)

	payload := MMSlashResponse{
		Username:    "Database Factory",
		IconURL:     "https://cdn2.iconfinder.com/data/icons/amazon-aws-stencils/100/Non-Service_Specific_copy__AWS_Cloud-128.png",
		Attachments: attachment,
	}
	err := send(os.Getenv("MattermostNotificationsHook"), payload)
	if err != nil {
		return errors.Wrap(err, "failed tο send Mattermost request payload")
	}
	return nil
}

func sendMattermostErrorNotification(errorMessage error, message string) error {
	attachment := []MMAttachment{}
	attach := MMAttachment{
		Color: "#FF0000",
	}

	attach = *attach.AddField(MMField{Title: message, Short: false}).
		AddField(MMField{Title: "Error Message", Value: errorMessage.Error(), Short: false})

	attachment = append(attachment, attach)

	payload := MMSlashResponse{
		Username:    "Database Factory",
		IconURL:     "https://cdn2.iconfinder.com/data/icons/amazon-aws-stencils/100/Non-Service_Specific_copy__AWS_Cloud-128.png",
		Attachments: attachment,
	}
	err := send(os.Getenv("MattermostAlertsHook"), payload)
	if err != nil {
		return errors.Wrap(err, "failed tο send Mattermost error payload")
	}
	return nil
}
