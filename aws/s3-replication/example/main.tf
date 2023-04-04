module "s3-enable-replication" {
  source                 = "git::https://github.com/mattermost/mattermost-cloud-monitoring.git//aws/s3-replication?ref=1.6.0"
  deployment_name        = var.deployment_name
  vpc_id                 = var.vpc_id
  source_bucket          = var.source_bucket
  source_region          = var.source_region
  destination_region     = var.destination_region
  destination_s3_kms_key = var.destination_s3_kms_key
  tags = {
    "Owner"     = "sre-team",
    "Terraform" = "true",
    "Purpose"   = "S3 Replication"
  }
}
