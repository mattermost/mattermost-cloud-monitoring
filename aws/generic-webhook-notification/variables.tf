variable "private_subnet_ids" {
  type        = list(string)
  description = "The list of the private subnet IDs are used by generic-webhook lambdas"
}

variable "vpc_id" {
  description = "The ID of VPC is used by the generic-webhook lambdas"
  type        = string
}

variable "deployment_name" {
  description = "The name of the deployment for Lambda"
  type        = string
}

variable "mattermost_webhook_prod" {
  type = string
}

variable "mattermost_webhook_alert_prod" {
  type = string
}

variable "pagerduty_integration_key" {
  type        = string
  description = "The integration key for the PagerDuty integration"
}

variable "mattermost_elrond_webhook_prod" {
  type = string
}

variable "mattermost_notification_hook" {
  type = string
}

variable "lambda_s3_bucket" {
  type        = string
  description = "The S3 bucket where the lambda function is stored"
}

variable "lambda_gitlab_webhook_s3_key" {
  type        = string
  description = "The S3 key where the gitlab webhook lambda function is stored"
}

variable "lambda_elrond_notification_s3_key" {
  type        = string
  description = "The S3 key where the elrond notification lambda function is stored"
}

variable "lambda_provisioner_notification_s3_key" {
  type        = string
  description = "The S3 key where the provisioner notification lambda function is stored"
}

variable "lambda_github_cursor_webhook_s3_key" {
  type        = string
  description = "The S3 key where the github-cursor-webhook lambda function is stored"
}

variable "github_cursor_webhook_n8n_url" {
  type        = string
  description = "Downstream n8n webhook URL that the github-cursor-webhook lambda forwards filtered events to"

  validation {
    condition     = can(regex("^https://", var.github_cursor_webhook_n8n_url))
    error_message = "github_cursor_webhook_n8n_url must be an https URL."
  }
}

variable "github_cursor_webhook_github_secret" {
  type        = string
  description = "Shared secret configured on the GitHub webhook; used to verify the X-Hub-Signature-256 HMAC on inbound requests"
  sensitive   = true

  validation {
    condition     = length(var.github_cursor_webhook_github_secret) >= 16
    error_message = "github_cursor_webhook_github_secret must be at least 16 characters."
  }
}

variable "github_cursor_webhook_n8n_api_key" {
  type        = string
  description = "API key sent as the X-API-KEY header on outbound forwards to the n8n workflow"
  sensitive   = true

  validation {
    condition     = length(var.github_cursor_webhook_n8n_api_key) >= 16
    error_message = "github_cursor_webhook_n8n_api_key must be at least 16 characters."
  }
}

variable "parent_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "enable_arm64" {
  description = "Enable ARM64 architecture for Lambda"
  type        = bool
  default     = false
}
