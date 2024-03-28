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
