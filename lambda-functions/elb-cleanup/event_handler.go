package main

import (
	"context"

	"github.com/aws/aws-lambda-go/events"
	"github.com/pkg/errors"
	log "github.com/sirupsen/logrus"
)

// EventHandler the struct which will handle
// CloudWatch events
type EventHandler struct {
	logger       log.FieldLogger
	awsResourcer Resourcer
	dryRun       bool
}

// NewEventHandler factory method to create a new
// event handler
func NewEventHandler(expirationDays int, awsResourcer Resourcer, dryRun bool, logger log.FieldLogger) *EventHandler {
	return &EventHandler{
		logger:       logger,
		awsResourcer: awsResourcer,
		dryRun:       dryRun,
	}
}

// Handle the event for cloudwatch events
func (h *EventHandler) Handle(_ context.Context, event events.CloudWatchEvent) error {
	h.logger.Info("Unused Load Balancer(s) cleanup function called")

	ctx, cancel := context.WithTimeout(context.Background(), awsTimeout)
	defer cancel()

	unUsedElbs, err := h.awsResourcer.ListUnusedElbs(ctx)
	if err != nil {
		return errors.Wrapf(err, "failed to list LBs")
	}
	for _, lb := range unUsedElbs {
		h.logger.Info("List of unused ALBs & NLBs are ", lb.LoadBalancerName)
	}
	h.logger.Info("Unused ALBs & NLBs count ", len(unUsedElbs))

	if !h.dryRun {
		// Delete unused ELBs
		err = h.awsResourcer.DeleteElbs(ctx, unUsedElbs)
		if err != nil {
			return errors.Wrapf(err, "failed to delete ELBs:")
		}
	}

	// classic LB
	unUsedClassiclbs, err := h.awsResourcer.ListUnUsedCalssiclbs(ctx)
	if err != nil {
		return errors.Wrapf(err, "failed to list classic LBs")
	}
	h.logger.Info("List of unused classic LBs are ", unUsedClassiclbs)
	h.logger.Info("Unused classic LBs count ", len(unUsedClassiclbs))

	// Delete classic ELBs
	if !h.dryRun {
		err = h.awsResourcer.DeleteCalssiclbs(ctx, unUsedClassiclbs)
		if err != nil {
			return errors.Wrapf(err, "failed to delete classic LBs")
		}
	}
	h.logger.WithField("eventID", event.ID).Info("event processed succesfully")
	return nil
}
