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

variable "kms_alias_name" {
  type    = string
  default = "alias/s3_placeholder_name"
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

variable "s3_bucket_tags" {
  type    = map(map(string))
  default = {}
}

variable "kms_key_tags" {
  type    = map(string)
  default = {}
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "s3_bucket_encryption" {
  type = map(object({
    sse_algorithm      = string
    kms_master_key_id  = string
    bucket_key_enabled = bool
  }))
  default = {}
}

variable "bypass_policy_lockout_safety_check" {
  type    = bool
  default = false
}
