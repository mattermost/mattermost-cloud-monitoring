variable "deployment_name" {
  type        = string
  description = "The name of the deployment"
}

variable "vpc_id" {
  type        = string
  description = "The vpc id which host the cluster & access the bucket"
}

variable "source_bucket" {
  type        = string
  description = "The Name of the source bucket for cross region replication"
}

variable "source_region" {
  type        = string
  description = "The name of the source bucket region"
}

variable "destination_region" {
  type        = string
  description = "The name of the destination bucket region"
}

variable "destination_s3_kms_key" {
  type        = string
  description = "The destination SSE KMS key to encrypt/decrypt the bucket data"
}

variable "tags" {
  description = "Tags for bucket & cost calculation"
  type        = map(string)
  default     = {}
}
