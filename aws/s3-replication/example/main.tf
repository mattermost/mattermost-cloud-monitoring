module "s3-enable-replication" {
  # source                              = "git::https://github.com/mattermost/mattermost-cloud-monitoring.git//aws/s3-replication?ref=v1.0.0"
  source                 = "/Users/muhammadshahid/mm-work/mattermost-cloud-monitoring/aws/s3-replication"
  deployment_name        = var.deployment_name
  vpc_id                 = var.vpc_id
  source_bucket          = var.source_bucket
  source_region          = var.source_region
  destination_region     = var.destination_region
  destination_s3_kms_key = var.destination_s3_kms_key
  tags = {
    "Owner"     = "my-team",
    "Terraform" = "true",
    "Purpose"   = "provisioning"
  }
}
