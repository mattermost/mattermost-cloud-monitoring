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
func NewEventHandler(awsResourcer Resourcer, dryRun bool, logger log.FieldLogger) *EventHandler {
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

	unUsedElbs, err := h.awsResourcer.ListUnusedElb(ctx)
	if err != nil {
		return errors.Wrapf(err, "failed to list ELBs")
	}

	h.logger.Info("Total Unused ElBs: ", len(unUsedElbs))
	if len(unUsedElbs) > 0 {
		for _, lb := range unUsedElbs {
			if !h.dryRun {
				// Delete unused ELBs
				err = h.awsResourcer.DeleteElb(ctx, lb.LoadBalancerArn)
				if err != nil {
					return errors.Wrapf(err, "failed to delete ELB %s:", *lb.LoadBalancerArn)
				}
				h.logger.Info("Deleted Unused ELB ", *lb.LoadBalancerArn)
			} else {
				h.logger.Info("Unused ELB is ", *lb.LoadBalancerArn)

			}
		}
	}

	// classic LB
	unUsedClassiclbs, err := h.awsResourcer.ListUnUsedClassiclb(ctx)
	if err != nil {
		return errors.Wrapf(err, "failed to list classic LBs")
	}

	h.logger.Info("Total Unused classic LBs: ", len(unUsedClassiclbs))
	if len(unUsedClassiclbs) > 0 {
		for _, classicLB := range unUsedClassiclbs {
			// Delete classic ELBs
			if !h.dryRun {
				err = h.awsResourcer.DeleteClassiclb(ctx, classicLB.LoadBalancerName)
				if err != nil {
					return errors.Wrapf(err, "failed to delete classic LBs %s", *classicLB.LoadBalancerName)
				}
				h.logger.Info("Deleted Unused classic LB ", *classicLB.LoadBalancerName)
			} else {
				h.logger.Info("Unused classic LB is ", *classicLB.LoadBalancerName)
			}
		}
	}

	h.logger.WithField("eventID", event.ID).Info("event processed succesfully")
	return nil
}
