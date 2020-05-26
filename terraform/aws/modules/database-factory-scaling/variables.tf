variable "private_subnet_ids" {}

variable "rds_multitenant_dbcluster_name_prefix" {}

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

variable "vpc_id" {}

variable "database_factory_horizontal_scaling_lambda_schedule" {}

variable "lambda_s3_bucket" {}

variable "lambda_s3_key" {}
