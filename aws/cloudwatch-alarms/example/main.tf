
module "cw_alarms" {
  source                    = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/cloudwatch-alarms?ref=v1.6.0"
  pagerduty_apikey          = var.pagerduty_apikey
  pagerduty_email_address   = var.pagerduty_email_address
  pagerduty_integration_key = var.pagerduty_integration_key
  community_webhook         = var.community_webhook
  environment               = var.environment
}
