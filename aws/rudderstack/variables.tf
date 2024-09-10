variable "workspace_id" {
  type        = string
  description = "Rudderstack workspace ID"
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name for pushing telemetry"
}
