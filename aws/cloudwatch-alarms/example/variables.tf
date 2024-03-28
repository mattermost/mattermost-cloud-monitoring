variable "pagerduty_apikey" {
  type        = string
  description = "The API key for the PagerDuty integration"
}

variable "community_webhook" {
  type        = string
  description = "The URL webhook to post the messages"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}
