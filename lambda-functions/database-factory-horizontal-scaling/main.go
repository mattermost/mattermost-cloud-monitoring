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
		sendMattermostErrorNotification(err, "The Database Factory horizontal scaling Lambda failed.")
		return
	}
	vpcList, err := getVPCs()
	if err != nil {
		log.WithError(err).Error("Unable to get VPCs")
		sendMattermostErrorNotification(err, "The Database Factory horizontal scaling Lambda failed.")
		return
	}
	_, err = checkDBClustersScaling(vpcList)
	if err != nil {
		log.WithError(err).Error("Unable to check DB cluster scaling")
		sendMattermostErrorNotification(err, "The Database Factory horizontal scaling Lambda failed.")
		return
	}
}

func checkEnvVariables() error {
	if os.Getenv("RDSMultitenantDBClusterNamePrefix") == "" {
		return errors.Errorf("Environment variable RDSMultitenantDBClusterNamePrefix was not set")
	}
	if os.Getenv("RDSMultitenantDBClusterTagPurpose") == "" {
		return errors.Errorf("Environment variable RDSMultitenantDBClusterTagPurpose was not set")
	}
	if os.Getenv("RDSMultitenantDBClusterTagDatabaseType") == "" {
		return errors.Errorf("Environment variable RDSMultitenantDBClusterTagDatabaseType was not set")
	}
	if os.Getenv("CounterLimit") == "" {
		return errors.Errorf("Environment variable CounterLimit was not set")
	}
	if os.Getenv("Environment") == "" {
		return errors.Errorf("Environment variable Environment was not set")
	}
	if os.Getenv("DBInstanceType") == "" {
		return errors.Errorf("Environment variable DBInstanceType was not set")
	}
	if os.Getenv("TerraformApply") == "" {
		return errors.Errorf("Environment variable TerraformApply was not set")
	}
	if os.Getenv("BackupRetentionPeriod") == "" {
		return errors.Errorf("Environment variable BackupRetentionPeriod was not set")
	}
	if os.Getenv("DatabaseFactoryEndpoint") == "" {
		return errors.Errorf("Environment variable DatabaseFactoryEndpoint was not set")
	}
	if os.Getenv("MattermostNotificationsHook") == "" {
		return errors.Errorf("Environment variable MattermostNotificationsHook was not set")
	}
	if os.Getenv("MattermostAlertsHook") == "" {
		return errors.Errorf("Environment variable MattermostAlertsHook was not set")
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
			bool, err := checkVPCScaling(dbClusters, vpc)
			if err != nil {
				return nil, errors.Wrap(err, "failed to check if cluster scaling is needed")
			}
			if bool {
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
	requestBody, err := json.Marshal(map[string]interface{}{
		"vpcID":                 vpc,
		"environment":           os.Getenv("Environment"),
		"stateStore":            os.Getenv("StateStore"),
		"apply":                 os.Getenv("TerraformApply"),
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
	sendMattermostNotification(databaseFactoryRequest, "A new RDS Cluster was successfully requested in the Database Factory.")
	log.Infof("The request was posted successfully %s", string(body))

	return nil
}

func checkVPCScaling(dbClusters *resourcegroupstaggingapi.GetResourcesOutput, vpc string) (bool, error) {
	var currentClusters int
	var limitCheck int
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
		currentClusters++
		for _, tag := range cluster.Tags {
			if *tag.Key == "Counter" && tag.Value != nil {
				counter = tag.Value
			}
		}
		counterInt, err := strconv.Atoi(*counter)
		if err != nil {
			return false, errors.Wrap(err, "failed tο change tag counter value into integer")
		}
		counterLimit, err := strconv.Atoi(os.Getenv("CounterLimit"))
		if counterInt >= counterLimit {
			limitCheck++
		}
	}
	if currentClusters == limitCheck {
		log.Infof("The VPC (%s) has %v deployed RDS Clusters and scaling is needed", vpc, currentClusters)
		return true, nil
	}
	log.Infof("The VPC (%s) has %v deployed RDS Clusters and no scaling is needed", vpc, currentClusters)
	return false, nil
}

func sendMattermostNotification(databaseFactoryRequest DatabaseFactoryRequest, message string) {

	attachment := []MMAttachment{}
	attach := MMAttachment{
		Color: "#006400",
	}

	attach = *attach.AddField(MMField{Title: message, Short: false})
	attach = *attach.AddField(MMField{Title: "VPCID", Value: databaseFactoryRequest.VPCID, Short: true})
	attach = *attach.AddField(MMField{Title: "Environment", Value: databaseFactoryRequest.Environment, Short: true})
	attach = *attach.AddField(MMField{Title: "StateStore", Value: databaseFactoryRequest.StateStore, Short: true})
	attach = *attach.AddField(MMField{Title: "Apply", Value: strconv.FormatBool(databaseFactoryRequest.Apply), Short: true})
	attach = *attach.AddField(MMField{Title: "InstanceType", Value: databaseFactoryRequest.InstanceType, Short: true})
	attach = *attach.AddField(MMField{Title: "BackupRetentionPeriod", Value: databaseFactoryRequest.BackupRetentionPeriod, Short: true})
	attach = *attach.AddField(MMField{Title: "ClusterID", Value: databaseFactoryRequest.ClusterID, Short: true})

	attachment = append(attachment, attach)

	payload := MMSlashResponse{
		Username:    "Database Factory",
		IconURL:     "https://cdn2.iconfinder.com/data/icons/amazon-aws-stencils/100/Non-Service_Specific_copy__AWS_Cloud-128.png",
		Attachments: attachment,
	}
	send(os.Getenv("MattermostNotificationsHook"), payload)
}

func sendMattermostErrorNotification(errorMessage error, message string) {

	attachment := []MMAttachment{}
	attach := MMAttachment{
		Color: "#FF0000",
	}

	attach = *attach.AddField(MMField{Title: message, Short: false})
	attach = *attach.AddField(MMField{Title: "Error Message", Value: errorMessage.Error(), Short: false})

	attachment = append(attachment, attach)

	payload := MMSlashResponse{
		Username:    "Database Factory",
		IconURL:     "https://cdn2.iconfinder.com/data/icons/amazon-aws-stencils/100/Non-Service_Specific_copy__AWS_Cloud-128.png",
		Attachments: attachment,
	}
	send(os.Getenv("MattermostAlertsHook"), payload)
}
