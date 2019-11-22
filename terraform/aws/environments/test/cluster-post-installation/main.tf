terraform {
  required_version = ">= 0.11"
  backend "s3" {
    bucket = "terraform-cloud-monitoring-state-bucket-test"
    key    = "mattermost-central-command-control-post-installation"
    region = "us-east-1"
  }
}


provider "aws" {
  region = var.region
  alias  = "post-deployment"
}


module "cluster-post-installation" {
  source = "../../../modules/cluster-post-installation"
  deployment_name = var.deployment_name
  region = var.region
  tiller_version = var.tiller_version
  kubeconfig_dir = var.kubeconfig_dir
  db_identifier = var.db_identifier
  allocated_db_storage = var.allocated_db_storage
  db_engine_version = var.db_engine_version
  db_instance_class = var.db_instance_class
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  db_backup_retention_period = var.db_backup_retention_period
  db_backup_window = var.db_backup_window
  db_subnet_group_name = var.db_subnet_group_name
  cidr_block_cec_cluster = var.cidr_block_cec_cluster
  db_maintenance_window = var.db_maintenance_window
  vpc_id = var.vpc_id
  mattermost_cloud_image = var.mattermost_cloud_image
  mattermost_cloud_ingress = var.mattermost_cloud_ingress
  snapshot_identifier = var.snapshot_identifier
  mattermost_cloud_secret_ssh_private = var.mattermost_cloud_secret_ssh_private
  mattermost_cloud_secret_ssh_public = var.mattermost_cloud_secret_ssh_public
  mattermost_cloud_secrets_aws_access_key = var.mattermost_cloud_secrets_aws_access_key
  mattermost_cloud_secrets_aws_secret_key = var.mattermost_cloud_secrets_aws_secret_key
  mattermost_cloud_secrets_aws_region = var.mattermost_cloud_secrets_aws_region
  mattermost_cloud_secrets_certificate_aws_arn = var.mattermost_cloud_secrets_certificate_aws_arn
  mattermost_cloud_secrets_database = var.mattermost_cloud_secrets_database
  mattermost_cloud_secrets_private_dns = var.mattermost_cloud_secrets_private_dns
  mattermost_cloud_secrets_private_route53_id = var.mattermost_cloud_secrets_private_route53_id
  mattermost_cloud_secrets_private_subnets = var.mattermost_cloud_secrets_private_subnets
  mattermost_cloud_secrets_public_subnets = var.mattermost_cloud_secrets_public_subnets
  mattermost_cloud_secrets_route53_id = var.mattermost_cloud_secrets_route53_id

  providers = {
    aws = "aws.post-deployment"
  }
}
