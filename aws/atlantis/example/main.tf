module "atlantis" {
  source                = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/atlantis?ref=v1.7.0"
  deployment_name       = var.deployment_name
  private_hosted_zoneid = var.private_hosted_zoneid
}
