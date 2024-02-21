variable "environment" {
  type        = string
  description = "The name of the environment is created"
}

variable "provisioner_users" {
  type        = list(string)
  description = "The list defined the users can use provisioner"
}

variable "force_destroy_state_bucket" {
  type        = bool
  description = "Enables force destroy of a provisioner state bucket"
  default     = false
}

variable "awat_cross_account_enabled" {
  type        = bool
  description = "Enables cross-account policies for KMS"
}

variable "awat_bucket_name" {
  type        = string
  description = "The name of the S3 Bucket which AWAT needs for data import"
}

variable "awat_s3_kms_key_arn" {
  type        = string
  description = "The name of the S3 Bucket which AWAT needs for data import"
}

variable "open_oidc_provider_url" {
  type        = string
  description = "The Open OIDC Provider URL for a specific cluster"
}

variable "open_oidc_provider_arn" {
  type        = string
  description = "The Open OIDC Provider ARN for a specific cluster"
}

variable "serviceaccount" {
  type        = string
  description = "Service Account, with which we want to associate IAM permission"
}

variable "namespace" {
  type        = string
  description = "The namespace, which host the service account & target application "
}
