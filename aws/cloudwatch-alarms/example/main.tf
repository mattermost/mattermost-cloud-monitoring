
module "cw_alarms" {
  source                  = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/cloudwatch-alarms?ref=v1.6.0"
  pagerduty_apikey        = var.pagerduty_apikey
  community_webhook       = var.community_webhook
  environment             = var.environment
}
