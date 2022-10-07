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

variable "private_hosted_zoneid" {
  type        = string
  description = "The ID of the Route53 private hosted zone"
}

variable "rds_writer_hostname" {
  type        = string
  description = "The RDS writer hostname"
}

variable "rds_reader_hostnames" {
  type        = list(string)
  description = "The RDS reader hostname, must be 3 elements. The first element is the generic reader hostname, the second is the primary reader, and the third is the secondary reader."
}
