variable "cloud_db_factory_horizontal_scaling_image" {}

variable "rds_multitenant_dbcluster_name_prefix" {}

variable "rds_multitenant_dbinstance_name_prefix" {}

variable "rds_multitenant_dbcluster_tag_purpose" {}

variable "rds_multitenant_dbcluster_tag_database_type" {}

variable "max_allowed_installations" {}

variable "environment" {}

variable "state_store" {}

variable "db_instance_type" {}

variable "terraform_apply" {}

variable "backup_retention_period" {}

variable "database_factory_endpoint" {}

variable "mattermost_notifications_hook" {}

variable "mattermost_alerts_hook" {}

variable "cloud_db_factory_hs_secrets_aws_access_key" {}

variable "cloud_db_factory_hs_secrets_aws_secret_key" {}

variable "cloud_db_factory_hs_secrets_aws_region" {}

variable "horizontal_scaling_cronjob_schedule" {}

variable "mattermost_cloud_namespace" {}

variable "database_factory_namespace" {}

variable "db_factory_horizontal_scaling_users" {}

variable "cloud_db_factory_vertical_scaling_image" {}

variable "cloud_db_factory_vs_secrets_aws_access_key" {}

variable "cloud_db_factory_vs_secrets_aws_secret_key" {}

variable "cloud_db_factory_vs_secrets_aws_region" {}

variable "vertical_scaling_cronjob_schedule" {}

variable "db_factory_vertical_scaling_users" {}

variable "rds_multitenant_dbcluster_tag_installation_database" {}

variable "horizontal_scaling_cronjob_suspend" {
  type    = bool
  default = false
}
