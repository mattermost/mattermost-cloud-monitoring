variable "vpc_id" {
  default = ""
  type    = string

}

variable "public_subnet_ids" {
  default = [""]
  type    = list(string)
}

variable "private_subnet_ids" {
  default = [""]
  type    = list(string)
}


variable "deployment_name" {
  default = "mattermost-cloud-gitlab"
  type    = string
}

variable "instance_type" {
  default = "m5.large"
  type    = string
}

variable "max_size" {
  default = "4"
  type    = string
}

variable "min_size" {
  default = "4"
  type    = string
}

variable "desired_capacity" {
  default = "4"
  type    = string
}

variable "region" {
  default = "us-east-1"
  type    = string
}

variable "environment" {
  default = "core"
  type    = string
}

variable "cidr_blocks" {
  default     = [""]
  type        = list(string)
  description = "CIDR to allow inbound cluster access"
}

variable "kubeconfig_dir" {
  default = "$HOME/generated/core"
  type    = string
}

variable "volume_size" {
  default = "50"
  type    = string
}

variable "eks_ami_id" {
  default     = "ami-0bf3e2c598f50ba82"
  type        = string
  description = "EKS Optimized AMI"
}

variable "key_name" {
  default     = ""
  type        = string
  description = "Core build keypair"
}

variable "tiller_version" {
  default = "2.16.1"
  type    = string
}

variable "gitlab_domain" {
  default = ""
}

variable "private_hosted_zoneid" {
  default = ""
}

variable "validation_hosted_zone_id" {
  default = ""
}

variable "gitlab_chart_version" {
  default = "v3.0.0"
}

variable "gitlab_s3_bucket_access_key_id" {
  default = ""
}

variable "gitlab_s3_bucket_secret_access_key" {
  default = ""
}

variable "gitlab_aws_region" {
  default = "us-east-1"
}

variable "db_identifier" {
  type    = string
  default = ""
}

variable "allocated_db_storage" {
  description = "The allocated storage in gigabytes for the DB"
  type        = string
  default     = 50
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

variable "smtp_password" {
  description = "Password for the smtp. Note that this may show up in logs, and it will be stored in the state file"
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
  default     = "05:01-05:31"
}

variable "db_maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = "Sun:02:00-Sun:03:00"
}

variable "snapshot_identifier" {
  description = "RDS Snapshot to restore"
  type        = string
  default     = null
}

variable "storage_encrypted" {
  type    = bool
  default = true
}

variable "install_gitlab_runner" {
  type    = bool
  default = true
}

variable "gitlab_registry_bucket" {
  type    = string
  default = ""
}

variable "gitlab_lfs_bucket" {
  type    = string
  default = ""
}

variable "gitlab_artifacts_bucket" {
  type    = string
  default = ""
}

variable "gitlab_uploads_bucket" {
  type    = string
  default = ""
}

variable "gitlab_packages_bucket" {
  type    = string
  default = ""
}

variable "gitlab_backup_bucket" {
  type    = string
  default = ""
}

variable "gitlab_tmp_bucket" {
  type    = string
  default = ""
}

variable "multi_az" {
  type    = bool
  default = true
}
