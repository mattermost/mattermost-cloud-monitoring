variable "pagerduty_apikey" {
  type        = string
  description = "The API key for the PagerDuty integration"
}

variable "pagerduty_email_address" {
  type        = string
  description = "The PagerDuty email address to use for alerting resolves"
}

variable "pagerduty_integration_key" {
  type        = string
  description = "The integration key for the PagerDuty integration"
}

variable "community_webhook" {
  type        = string
  description = "The URL webhook to post the messages"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

variable "lambda_s3_bucket" {
  type        = string
  description = "The S3 bucket where the lambda function is stored"
}

variable "lambda_alert_elb_s3_key" {
  type        = string
  description = "The S3 key where the alert ELB alarm lambda function is stored"
}

variable "lambda_create_elb_s3_key" {
  type        = string
  description = "The S3 key where the create ELB alarm lambda function is stored"
}

variable "lambda_create_rds_s3_key" {
  type        = string
  description = "The S3 key where the create RDS alarm lambda function is stored"
}

variable "enable_arm64" {
  description = "Enable ARM64 architecture for Lambda"
  type        = bool
  default     = false
}
