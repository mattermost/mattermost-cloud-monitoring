variable "environment" {
  type        = string
  description = "The name of the environment is created"
}

variable "deployment_name" {
  type        = string
  description = "The name of the deployment which exists in"
}

variable "provisioner_users" {
  type        = list(string)
  description = "The list defined the users can use provisioner"
}

variable "cnc_user" {
  type        = string
  description = "The Command And Control user"
}

variable "force_destroy_state_bucket" {
  type        = bool
  description = "Enables force destroy of a provisioner state bucket"
  default     = false
}

variable "force_destroy_stackrox_bundle_bucket" {
  type        = bool
  description = "Enables force destroy of a stackrox bundle bucket"
  default     = false
}

variable "awat_bucket_name" {
  type        = string
  description = "The name of the S3 Bucket which AWAT needs for data import"
}
