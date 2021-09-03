package main

import (
	"context"
	"time"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/pkg/errors"
	log "github.com/sirupsen/logrus"
)

// EventHandler the struct which will handle
// CloudWatch events
type EventHandler struct {
	logger         log.FieldLogger
	awsResourcer   Resourcer
	expirationDays int
	dryRun         bool
}

// NewEventHandler factory method to create a new
// event handler
func NewEventHandler(expirationDays int, awsResourcer Resourcer, dryRun bool, logger log.FieldLogger) *EventHandler {
	return &EventHandler{
		logger:         logger,
		awsResourcer:   awsResourcer,
		dryRun:         dryRun,
		expirationDays: expirationDays,
	}
}

// Handle the event for cloudwatch events
func (h *EventHandler) Handle(_ context.Context, event events.CloudWatchEvent) error {
	h.logger.WithField("eventID", event.ID).Info("event processing")

	ctx, cancel := context.WithTimeout(context.Background(), awsTimeout)
	defer cancel()
	results, err := h.awsResourcer.ListVolumes(ctx, ec2.VolumeStateAvailable)
	if err != nil {
		return errors.Wrapf(err, "failed to list EBS for State: %s", ec2.VolumeStateAvailable)
	}
	h.logger.WithField("count", len(results)).Info("found available EBS")

	for _, v := range results {
		fields := log.Fields{
			"ID":         *v.VolumeId,
			"createdAt":  *v.CreateTime,
			"snapshotID": *v.SnapshotId,
		}
		// skip under conditions
		if shouldSkipVolume(v, h.expirationDays) {
			h.logger.WithFields(fields).Info("skipped volume")
			continue
		}
		h.logger.WithFields(fields).Info("volume to be deleted")
		ctx, cancel = context.WithTimeout(context.Background(), awsTimeout)
		defer cancel()
		if h.dryRun {
			continue
		}
		if err := h.awsResourcer.DeleteVolume(ctx, v.VolumeId); err != nil {
			h.logger.WithFields(fields).Error("failed to delete volume")
			return errors.Wrapf(err, "failed to delete volume with ID: %s", *v.VolumeId)
		}
		h.logger.WithFields(fields).Info("deleted volume")
	}
	h.logger.WithField("eventID", event.ID).Info("event processed succesfully")
	return nil
}

func shouldSkipVolume(v *ec2.Volume, expirationDays int) bool {
	if *v.SnapshotId != "" {
		return true
	}
	daysByCreationTime := time.Since(*v.CreateTime).Hours() / 24
	return daysByCreationTime < float64(expirationDays)
}
