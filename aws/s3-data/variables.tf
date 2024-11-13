variable "bucket_name" {
  type        = string
  description = "The name of the bucket"
}

variable "iam_user_name" {
  type        = string
  description = "The name of the IAM user to access the bucket"
}

variable "s3_bucket_enable_versioning" {
  type        = string
  default     = true
  description = "If the s3 bucket versioning to be enabled"
}
