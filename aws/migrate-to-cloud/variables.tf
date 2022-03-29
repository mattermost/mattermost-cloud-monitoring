variable "region" {
  type        = string
  description = "The AWS region which will be used."
}

variable "account_id" {
  type        = string
  description = "The AWS account ID which will be used."
}

variable "bucket" {
  type        = string
  description = "The S3 bucket where the binary is located"
}

variable "customer_bucket_folder" {
  type        = string
  description = "The S3 bucket folder where the binary is located"
}

variable "customer_policy_name" {
  type        = string
  description = "The customer IAM policy name"
}

variable "kms_key" {
  type        = string
  description = "The kms_key we use"
}
