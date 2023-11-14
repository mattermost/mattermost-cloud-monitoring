variable "mattermost_webhook_prod" {
  type = string
}

variable "mattermost_webhook_alert_prod" {
  type = string
}

variable "opsgenie_apikey" {
  type = string
}

variable "opsgenie_scheduler_team" {
  type = string
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
