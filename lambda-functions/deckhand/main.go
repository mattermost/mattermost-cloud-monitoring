package main

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/aws/aws-lambda-go/lambda"

	"github.com/pkg/errors"

	log "github.com/sirupsen/logrus"
	"os"
	"strconv"
	"strings"
	"time"
)

func main() {
	log.SetLevel(log.DebugLevel)

	lambda.Start(handler)
}

func handler() {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(os.Getenv("REGION"))},
	)
	if err != nil {
		log.WithError(err).Error("AWS Session failed.")
		return
	}
	svc := ec2.New(sess)
	uniqueUsedImages, err := getUniqueUsedImages(svc)
	if err != nil {
		log.WithError(err).Error("Failed to get Unique Used AMIs.")
		return
	}
	err = deleteAMIs(svc, uniqueUsedImages)

	if err != nil {
		log.WithError(err).Error("Failed to delete AMIs.")
		return
	}
}

func deleteAMIs(svc *ec2.EC2, uniqueUsedImages []string) error {
	imagesInput := &ec2.DescribeImagesInput{
		Owners: []*string{
			aws.String(os.Getenv("OWNER_ID")),
		},
		Filters: []*ec2.Filter{
			{
				Name:   aws.String("tag:Name"),
				Values: []*string{aws.String("mattermost-cloud-*")},
			},
		},
	}
	snapshots, err := getAllSnapshots(os.Getenv("OWNER_ID"), svc)
	if err != nil {
		return errors.Wrap(err, "Failed to get Snapshots.")
	}
	allImages, err := svc.DescribeImages(imagesInput)
	if err != nil {
		return errors.Wrap(err, "Failed to describe images.")
	}
	oldImages, err := filterImagesByDateRange(allImages.Images, 730)
	if err != nil {
		return errors.Wrap(err, "Failed to filter images by date range.")
	}
	dryRun := false
	for _, i := range oldImages {
		imageForCleanup := contains(uniqueUsedImages, *i.ImageId)
		if imageForCleanup != "" {
			log.Info(*i.ImageId + ": De-registering AMI named \"" + *i.Name + "\"...")
			cleanupImageInput := &ec2.DeregisterImageInput{
				ImageId: &imageForCleanup,
				DryRun:  &dryRun,
			}
			_, err := svc.DeregisterImage(cleanupImageInput)
			if err != nil {
				return errors.Wrapf(err, "Failed to deregister AMI %s", *i.ImageId)
			}
			var snapshotIds []string
			for _, snapshot := range snapshots {
				if strings.Contains(*snapshot.Description, *i.ImageId) {
					snapshotIds = append(snapshotIds, *snapshot.SnapshotId)
				}
			}
			log.Info(*i.ImageId + ": Found " + strconv.Itoa(len(snapshotIds)) + " snapshot(s) to delete")
			for _, snapshotId := range snapshotIds {
				log.Info(*i.ImageId + ": Deleting snapshot " + snapshotId + "...")
				_, deleteErr := svc.DeleteSnapshot(&ec2.DeleteSnapshotInput{
					DryRun:     &dryRun,
					SnapshotId: &snapshotId,
				})

				if deleteErr != nil {
					return errors.Wrapf(err, "Failed to delete Snapshot %s", snapshotId)
				}
			}
		} else {
			log.Info("Image " + *i.ImageId + " is used on a current running instance.")
		}

	}
	return nil
}

func getUniqueUsedImages(svc *ec2.EC2) ([]string, error) {

	instancesInput := &ec2.DescribeInstancesInput{}
	encountered := make(map[string]bool)
	runningInstances, err := svc.DescribeInstances(instancesInput)
	if err != nil {
		return nil, err
	}
	for _, i := range runningInstances.Reservations {
		for _, k := range i.Instances {
			encountered[*k.ImageId] = true
		}
	}

	uniqueUsedImages := []string{}
	for image := range encountered {
		uniqueUsedImages = append(uniqueUsedImages, image)
	}

	return uniqueUsedImages, nil
}

func contains(arr []string, str string) string {
	for _, a := range arr {
		if a == str {
			return ""
		}
	}
	return str
}

func filterImagesByDateRange(images []*ec2.Image, olderThanHours float64) ([]*ec2.Image, error) {
	var filteredAmis []*ec2.Image

	for i := 0; i < len(images); i++ {
		now := time.Now()
		creationDate, err := time.Parse(time.RFC3339Nano, *images[i].CreationDate)
		if err != nil {
			return filteredAmis, err
		}

		duration := now.Sub(creationDate)

		if duration.Hours() > olderThanHours {
			filteredAmis = append(filteredAmis, images[i])
		}
	}

	return filteredAmis, nil
}

func getAllSnapshots(awsAccountId string, svc *ec2.EC2) ([]*ec2.Snapshot, error) {
	var noSnapshots []*ec2.Snapshot

	respDscrSnapshots, err := svc.DescribeSnapshots(&ec2.DescribeSnapshotsInput{
		OwnerIds: []*string{&awsAccountId},
	})
	if err != nil {
		return noSnapshots, err
	}

	return respDscrSnapshots.Snapshots, nil
}
