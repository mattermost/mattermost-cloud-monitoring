variable "environment" {}

variable "vpc_id" {}

variable "region" {}

variable "cloud_vpn_cidr" {}

variable "db_identifier" {}

variable "allocated_db_storage" {}

variable "db_engine_version" {}

variable "db_instance_class" {}

variable "db_master_az" {}

variable "db_read_replica_az" {}

variable "db_name" {}

variable "db_username" {}

variable "db_password" {}

variable "mattermost_cloud_ingress" {}

variable "db_backup_retention_period" {}

variable "db_backup_window" {}

variable "db_maintenance_window" {}

variable "snapshot_identifier" {}

variable "storage_encrypted" {}

variable "mattermost_cloud_image" {}

variable "mattermost-cloud-namespace" {}

variable "mattermost_cloud_secrets_aws_region" {}

variable "mattermost_cloud_secrets_keep_filestore_data" {}

variable "mattermost_cloud_secrets_keep_database_data" {}

variable "mattermost_cloud_secret_ssh_private" {}

variable "mattermost_cloud_secret_ssh_public" {}

variable "private_subnets" {}

variable "domain" {}

variable "private_hosted_zoneid" {}

variable "deployment_name" {}

variable "tiller_version" {}

variable "kubeconfig_dir" {}

variable "provisioner_name" {
  type    = string
  default = "provisioner"
}

variable "db_deletion_protection" {
  type    = bool
  default = true
}

variable "provider_role_arn" {
  type    = string
  default = ""
}
variable "provisioner_users" {}

variable "whitelist_source_range" {}

variable "gitlab_oauth_token" {}
