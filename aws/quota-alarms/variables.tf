variable "metrics" {
  type        = list(string)
  description = "The list of metrics to setup a CloudWatch Metric alarm"
}

variable "alarm_threshold" {
  type        = string
  description = "The threshold which is used for CloudWatch Metric alarm"
}
