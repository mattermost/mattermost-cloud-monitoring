module "provisioner-read-only-users" {
  source                     = "git::https://github.com/mattermost/mattermost-cloud-monitoring.git//aws/provisioner-read-only-users?ref=v1.0.0"
  environment                = var.environment
  provisioner_users          = var.provisioner_read_only_users
  deployment_name            = var.deployment_name
}