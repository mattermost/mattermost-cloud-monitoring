terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "terraform-cloud-monitoring-state-bucket-core"
    key    = "mattermost-cloud-gitlab"
    region = "us-east-1"
  }
}


provider "aws" {
  region = var.region
  alias  = "deployment"
}

module "cluster" {
  source             = "../../../modules/eks-cluster"
  public_subnet_ids  = [var.public_subnet_ids]
  private_subnet_ids = [var.private_subnet_ids]
  vpc_id             = var.vpc_id
  deployment_name    = var.deployment_name
  instance_type      = var.instance_type
  max_size           = var.max_size
  min_size           = var.min_size
  desired_capacity   = var.desired_capacity
  cidr_blocks        = var.cidr_blocks
  kubeconfig_dir     = var.kubeconfig_dir
  volume_size        = var.volume_size
  environment        = var.environment
  region             = var.region
  key_name           = var.key_name
  eks_ami_id         = var.eks_ami_id
  providers = {
    aws = aws.deployment
  }
}

module "gitlab" {
  source                             = "../../../modules/gitlab"
  deployment_name                    = var.deployment_name
  kubeconfig_dir                     = var.kubeconfig_dir
  tiller_version                     = var.tiller_version
  gitlab_domain                      = var.gitlab_domain
  private_hosted_zoneid              = var.private_hosted_zoneid
  validation_hosted_zone_id          = var.validation_hosted_zone_id
  gitlab_chart_version               = var.gitlab_chart_version
  gitlab_s3_bucket_access_key_id     = var.gitlab_s3_bucket_access_key_id
  gitlab_s3_bucket_secret_access_key = var.gitlab_s3_bucket_secret_access_key
  gitlab_aws_region                  = var.gitlab_aws_region
  vpc_id                             = var.vpc_id
  private_subnets                    = var.private_subnet_ids
  db_identifier                      = var.db_identifier
  allocated_db_storage               = var.allocated_db_storage
  db_engine_version                  = var.db_engine_version
  db_instance_class                  = var.db_instance_class
  db_name                            = var.db_name
  db_username                        = var.db_username
  db_password                        = var.db_password
  smtp_password                      = var.smtp_password
  db_backup_retention_period         = var.db_backup_retention_period
  db_backup_window                   = var.db_backup_window
  db_maintenance_window              = var.db_maintenance_window
  snapshot_identifier                = var.snapshot_identifier
  storage_encrypted                  = var.storage_encrypted
  gitlab_security_group              = module.cluster.worker_security_group
  install_gitlab_runner              = var.install_gitlab_runner
  gitlab_registry_bucket             = var.gitlab_registry_bucket
  gitlab_lfs_bucket                  = var.gitlab_lfs_bucket
  gitlab_artifacts_bucket            = var.gitlab_artifacts_bucket
  gitlab_uploads_bucket              = var.gitlab_uploads_bucket
  gitlab_packages_bucket             = var.gitlab_packages_bucket
  gitlab_backup_bucket               = var.gitlab_backup_bucket
  gitlab_tmp_bucket                  = var.gitlab_tmp_bucket
  multi_az                           = var.multi_az
  smtp_user_name                     = var.smtp_user_name
  smtp_address                       = var.smtp_address
}
