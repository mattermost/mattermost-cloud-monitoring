variable "environment" {
  type        = string
  description = "The name of the environment"
}

variable "protected_resources" {
  type        = map(string)
  description = "As key the name and as value the ARN of the resource to be protected"
}

variable "vpc_flow_logs_env" {
  type        = string
  description = "The name of the log destination of VPC flow logs"
}

variable "enable_flow_logs" {
  type        = bool
  default     = true
  description = "The flag is used to enable or disable flow logs accordingly"
}
