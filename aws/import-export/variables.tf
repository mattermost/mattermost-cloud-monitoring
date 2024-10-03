variable "kms_key_description" {
  description = "Description for the customer managed KMS key"
  type        = string
  default     = "Customer managed KMS key for S3 buckets"
}

variable "s3_buckets" {
  description = "List of S3 buckets to manage"
  type        = list(string)
  default     = []
}

variable "s3_bucket_policies" {
  description = "Map of bucket names to their respective policies"
  type        = map(string)
  default     = {}
}

variable "other_account_id" {
  description = "AWS Account ID that needs access to the KMS key"
  type        = string
}

variable "other_account_user_name" {
  description = "User name in the other AWS account that needs access to the KMS key"
  type        = string
}

variable "other_account_role_name" {
  description = "Role name in the other AWS account that needs access to the KMS key"
  type        = string
}

