variable "opsgenie_apikey" {
  type        = string
  description = "The API key for the OPSGenie integration"
}

variable "opsgenie_scheduler_team" {
  type        = string
  description = "The opsgenie scheduler team uuid  - not used on dev"
}

variable "community_webhook" {
  type        = string
  description = "The URL webhook to post the messages"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}
