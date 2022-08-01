module "community-on-demand" {
  source          = "git::https://github.com/mattermost/mattermost-cloud-monitoring.git//aws/community-on-demand?ref=v1.18.1"
  environment     = var.environment
  vpc_id          = var.vpc_id
  deployment_name = var.deployment_name
  tags = {
    "Filestore"   = "Multitenant",
    "Owner"       = "sre-team",
    "Terraform"   = "true",
    "VpcID"       = var.vpc_id,
    "Environment" = var.environment,
    "Purpose"     = "Community On Demanad testing"
  }
}
