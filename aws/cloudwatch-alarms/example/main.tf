
module "cw_alarms" {
  source                  = "github.com/mattermost/mattermost-terraform-modules.git//aws/cloudwatch-alarms?ref=v1.0.0"
  opsgenie_apikey         = var.opsgenie_apikey
  opsgenie_scheduler_team = var.opsgenie_scheduler_team
  community_webhook       = var.community_webhook
  environment             = var.environment
}
