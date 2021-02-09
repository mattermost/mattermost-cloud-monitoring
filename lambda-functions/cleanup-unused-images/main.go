package main

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	log "github.com/sirupsen/logrus"
)

func main() {
	log.SetLevel(log.DebugLevel)

	lambda.Start(handler)
}

func handler() {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(os.Getenv("AWS_REGION"))},
	)

	svc := ec2.New(sess)
	uniqueUsedImages, err := getUniqueUsedImages(svc)
	err = deleteAMIs(svc,uniqueUsedImages)

	fmt.Println(uniqueUsedImages)

	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			default:
				log.WithError(aerr.Error("AWS Error."))
			}
		} else {
			// Print the error, cast err to awserr.Error to get the Code and
			// Message from an error.
			log.WithError(err).Error("AWS Error.")
		}
		return
	}
}

func deleteAMIs(svc *ec2.EC2, uniqueUsedImages []string) (error) {
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
	allImages, err := svc.DescribeImages(imagesInput)
	oldImages, err := filterImagesByDateRange(allImages.Images, 730)
	dryRun := true
	for _, i := range oldImages {
		imageForCleanup := contains(uniqueUsedImages, *i.ImageId)
		fmt.Println(imageForCleanup)
		fmt.Println(*i.ImageId + ": De-registering AMI named \"" + *i.Name + "\"...")
		cleanupImageInput := &ec2.DeregisterImageInput{
		ImageId: &imageForCleanup,
		DryRun: &dryRun,
		}
		cleanupImage, _ := svc.DeregisterImage(cleanupImageInput)
		fmt.Println(cleanupImage)
		var snapshotIds []string
		for _, snapshot := range snapshots {
			if strings.Contains(*snapshot.Description, *i.ImageId) {
				snapshotIds = append(snapshotIds, *snapshot.SnapshotId)
			}
		}
		fmt.Println(snapshotIds)
		fmt.Println(*i.ImageId + ": Found " + strconv.Itoa(len(snapshotIds)) + " snapshot(s) to delete")
		for _, snapshotId := range snapshotIds {
			fmt.Println(*i.ImageId + ": Deleting snapshot " + snapshotId + "...")
			_, deleteErr := svc.DeleteSnapshot(&ec2.DeleteSnapshotInput{
				DryRun:     &dryRun,
				SnapshotId: &snapshotId,
			})

			if deleteErr != nil {
				log.WithError(deleteErr.Error("Failed to delete Snapshot " + snapshotId + "."))
			}
		}

	}
	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			default:
				fmt.Println(aerr.Error())
			}
		} else {
			// Print the error, cast err to awserr.Error to get the Code and
			// Message from an error.
			fmt.Println(err.Error())
		}
	}

	return err
}

func getUniqueUsedImages(svc *ec2.EC2) ([]string, error) {

	instancesInput := &ec2.DescribeInstancesInput{}
	encountered := make(map[string]struct{})
	uniqueUsedImages := make([]string, 0)
	duplicateImages := make([]string, 0)

	runningInstances, err := svc.DescribeInstances(instancesInput)
	for _, i := range runningInstances.Reservations {
		for _, k := range i.Instances {
			if _, ok := encountered[*k.ImageId]; ok {
				duplicateImages = append(duplicateImages, *k.ImageId)
				continue
			}else {
				encountered[*k.ImageId] = struct{}{}
				uniqueUsedImages = append(uniqueUsedImages, *k.ImageId)
			}
		}
	}

	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			default:
				fmt.Println(aerr.Error())
			}
		} else {
			// Print the error, cast err to awserr.Error to get the Code and
			// Message from an error.
			fmt.Println(err.Error())
		}
	}

	return uniqueUsedImages, err
}

func contains(arr []string, str string) string {
	for _, a := range arr {
		if a == str {
			continue
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
