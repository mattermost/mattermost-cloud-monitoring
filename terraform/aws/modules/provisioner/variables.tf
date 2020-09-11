variable "environment" {}

variable "vpc_id" {}

variable "region" {}

variable "cloud_vpn_cidr" {}

variable "db_identifier" {}

variable "allocated_db_storage" {}

variable "db_engine_version" {}

variable "db_instance_class" {}

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

variable "mattermost_cloud_secrets_private_dns" {}

variable "mattermost_cloud_secrets_keep_filestore_data" {}

variable "mattermost_cloud_secrets_keep_database_data" {}

variable "mattermost_cloud_secret_ssh_private" {}

variable "mattermost_cloud_secret_ssh_public" {}

variable "private_subnets" {}

variable "domain" {}

variable "validation_acm_zoneid" {}

variable "private_hosted_zoneid" {}

variable "provisioner_users" {}
