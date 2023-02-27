variable "deployment_name" {
  type        = string
  description = "The name of the deployment"
  default     = "test-replication"
}

variable "vpc_id" {
  type        = string
  description = "The vpc id which host the cluster & access the bucket"
  default     = "vpc-id"
}

variable "source_bucket" {
  type        = string
  description = "The Name of the source bucket for cross region replication"
  default     = "source-bucket"
}

variable "source_region" {
  type        = string
  description = "The name of the source bucket region"
  default     = "us-east-1"
}

variable "destination_region" {
  type        = string
  description = "The name of the destination bucket region"
  default     = "aws region"
}

variable "destination_s3_kms_key" {
  type        = string
  description = "The destination SSE KMS key to encrypt/decrypt the bucket data"
  default     = "arn:aws:kms:region:xxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

variable "tags" {
  description = "Tags for bucket & cost calculation"
  type        = map(string)
  default     = {}
}
