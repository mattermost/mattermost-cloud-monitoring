package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/events"
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
	fmt.Println("List LBs are working test")
	h.logger.WithField("eventID", event.ID).Info("event processing")

	ctx, cancel := context.WithTimeout(context.Background(), awsTimeout)
	defer cancel()

	lbs, err := h.awsResourcer.DeleteElbs(ctx)
	if err != nil {
		return errors.Wrapf(err, "failed to list LBs:")
	}
	// fmt.Println("List ALBs & NLBs are ", lbs)
	// fmt.Println("List ALBs & NLBs count ", len(lbs))
	h.logger.Info("List ALBs & NLBs are ", lbs)
	h.logger.Info("List ALBs & NLBs count ", len(lbs))

	// classic LB
	lbs, err = h.awsResourcer.DeleteCalssiclbs(ctx)
	if err != nil {
		return errors.Wrapf(err, "failed to list classic LBs:")
	}
	h.logger.Info("List ALBs & NLBs are ", lbs)
	h.logger.Info("List ALBs & NLBs count ", len(lbs))
	return nil
}
