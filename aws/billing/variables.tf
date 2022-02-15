variable "environment" {
  type        = string
  description = "The name of the environment"

}
variable "amount" {
  type        = string
  description = "The amount of cost or usage being measured for a budget"
}
variable "currency" {
  type        = string
  description = "The unit of measurement used for the budget eg. USD"
}
variable "threshold" {
  type        = string
  description = "The threshold when the notification should be sent"
}
variable "emails" {
  type        = string
  description = "The emails in which the notification should be sent"
}
variable "sns_topic_arns" {
  type        = string
  description = "The emails in which the notification should be sent"
}
