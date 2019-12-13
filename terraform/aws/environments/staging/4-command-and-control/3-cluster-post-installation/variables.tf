variable "environment" {
  default = "staging"
  type    = string
}

variable "deployment_name" {
  default = "mattermost-central-command-control"
  type    = string
}

variable "region" {
  default = "us-east-1"
  type    = string
}

variable "tiller_version" {
  default = "2.14.1"
  type    = string
}

variable "kubeconfig_dir" {
  default = "$HOME/generated"
  type    = string
}

variable "grafana_tls_crt" {
  default = ""
  type    = string
}

variable "grafana_tls_key" {
  default = ""
  type    = string
}

variable "prometheus_tls_crt" {
  default = ""
  type    = string
}

variable "prometheus_tls_key" {
  default = ""
  type    = string
}

variable "kibana_tls_crt" {
  default = ""
  type    = string
}

variable "kibana_tls_key" {
  default = ""
  type    = string
}

variable "storage_encrypted" {
  type    = bool
  default = true
}

variable "db_identifier" {
  type    = string
  default = ""
}

variable "allocated_db_storage" {
  description = "The allocated storage in gigabytes for the DB"
  type        = string
  default     = 20
}

variable "db_engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "11.5"
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t2.medium"
}

variable "db_name" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = ""
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
  default     = ""
}

variable "db_password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
  default     = ""
}

variable "db_backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 7
}

variable "db_backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = "12:01-12:31"
}

variable "db_maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = "Sun:02:00-Sun:03:00"
}

variable "private_subnets" {
  type    = list(string)
  default = ["", "", ""]
}

variable "vpc_id" {
  description = "VPC to associate the SG"
  type        = string
  default     = ""
}

variable "mattermost_cloud_image" {
  default = "mattermost/mattermost-cloud:latest"
}

variable "mattermost_cloud_ingress" {
  default = ""
}

variable "snapshot_identifier" {
  description = "RDS Snapshot to restore"
  type        = string
  default     = null
}

variable "mattermost-cloud-namespace" {
  type    = string
  default = ""
}

variable "mattermost_cloud_secret_ssh_private" {
  type    = string
  default = ""
}

variable "mattermost_cloud_secret_ssh_public" {
  type    = string
  default = ""
}

variable "mattermost_cloud_secrets_aws_access_key" {
  type    = string
  default = ""
}

variable "mattermost_cloud_secrets_aws_secret_key" {
  type    = string
  default = ""
}

variable "mattermost_cloud_secrets_aws_region" {
  default = "us-east-1"
}

variable "mattermost_cloud_secrets_certificate_aws_arn" {
  type    = string
  default = ""
}

variable "mattermost_cloud_secrets_private_dns" {
  type    = string
  default = ""
}

variable "mattermost_cloud_secrets_private_route53_id" {
  type    = string
  default = ""
}

variable "mattermost_cloud_secrets_route53_id" {
  type    = string
  default = ""
}

variable "provisioner_user" {}
