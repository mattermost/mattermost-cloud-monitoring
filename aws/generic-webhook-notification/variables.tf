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

variable "pagerduty_apikey" {
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

variable "parent_id" {
  type = string
}

variable "tags" {
  type = map(string)
}
