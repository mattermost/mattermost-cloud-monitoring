variable "environment" {
  description = "The environment"
  type        = string
}

variable "create_packer_role" {
  description = "Whether to create the packer role"
  type        = bool
  default     = false
}

variable "create_db_disaster_role" {
  description = "Whether to create the DB disaster recovery role"
  type        = bool
  default     = false
}

variable "create_exports_user" {
  description = "Whether to create the exports user"
  type        = bool
  default     = false
}

variable "exports_bucket_arn" {
  description = "The bucket that will be used for data exports. Needed only when create_exports_users is set to true"
  type        = string
  default     = ""
}

variable "github_runners_iam_role_arn" {
  description = "Github runner role ARN"
  type        = string
  default     = ""
}

variable "create_plugin_store_role" {
  description = "Whether to create the plugin store role"
  type        = bool
  default     = false
}

variable "github_repos_sub" {
  description = "Github repos sub"
  type        = list(string)
  default     = []
}

variable "create_private_role" {
  description = "Whether to create the private role"
  type        = bool
  default     = false
}

variable "create_pulumi_github_sync_role" {
  description = "Whether to create the pulumi-github-sync role"
  type        = bool
  default     = false
}
