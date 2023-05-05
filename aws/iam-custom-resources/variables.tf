variable "environment" {
  description = "The environment"
  type        = string
}

variable "create_packer_user" {
  description = "Whether to create the packer user"
  type        = bool
  default     = false
}

variable "create_db_disaster_user" {
  description = "Whether to create the DB disaster recovery user"
  type        = bool
  default     = false
}

variable "create_apps_deployer_user" {
  description = "Whether to create the Apps Deployer user"
  type        = bool
  default     = false
}

variable "apps_deployer_assume_role_arn" {
  description = "The ARN of the role to assume for the apps deployer user"
  type        = string
}
