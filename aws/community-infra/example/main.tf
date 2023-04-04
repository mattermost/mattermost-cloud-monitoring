module "community-dr-infra" {
  source                              = "git::https://github.com/mattermost/mattermost-cloud-monitoring.git//aws/community-infra?ref=v1.6.0"
  environment                         = "Testing"
  vpc_id                              = var.vpc_id
  deployment_name                     = var.deployment_name
  destination_bucket                  = var.destination_bucket
  s3_cross_region_replication_enabled = true
  destination_s3_kms_key              = var.destination_s3_kms_key
  tags = {
    "Owner"     = "my-team",
    "Terraform" = "true",
    "Purpose"   = "provisioning"
  }
}
