variable "environment" {
  type        = string
  description = "The environment name like staging, staging-dr, prod etc where we want to setup resources"
}

variable "deployment_name" {
  type        = string
  description = "The name of the deployment"
}

variable "vpc_id" {
  type        = string
  description = "The vpc id which host the cluster & access the bucket"
}

variable "destination_bucket" {
  type        = string
  description = "The ARN of the destination bucket for cross region replication"
}

variable "destination_s3_kms_key" {
  type        = string
  description = "The destination SSE KMS key to encrypt/decrypt the bucket data"
}

variable "s3_cross_region_replication_enabled" {
  type        = bool
  default     = true
  description = "Cross region replication flag for the bucket"
}


variable "tags" {
  description = "Tags for bucket & cost calculation"
  type        = map(string)
  default     = {}
}
