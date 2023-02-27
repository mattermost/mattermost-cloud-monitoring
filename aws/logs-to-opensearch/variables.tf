variable "private_subnet_ids" {
  type        = list(string)
  description = "The list of the private subnet IDs are used by logs-to-opensearch lambda"
}
variable "vpc_id" {
  description = "The ID of VPC is used by the logs-to-opensearch lamda"
  type        = string
}

variable "deployment_name" {
  description = "The name of the deployment for Lambda"
  type        = string
}

variable "bucket" {
  description = "S3 bucket where the logs-to-opensearch lambda is stored"
  type        = string
}

variable "es_endpoint" {
  description = "The endpoint of AWS Opensearch service"
  type        = string
}

variable "alarm_period" {
  default     = 10800
  description = "The period in seconds over which the specified statistic is applied"
  type        = number
}

variable "alarm_evaluation_periods" {
  default     = 1
  description = "The number of periods over which data is compared to the specified threshold"
  type        = number
}

variable "alarm_threshold" {
  default     = 1
  description = "The value against which the specified statistic is compared"
  type        = number
}
