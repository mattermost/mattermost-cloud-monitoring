variable "vpc_flow_logs_env" {
  type        = string
  description = "The name of the log destination of VPC flow logs"
}

variable "enable_flow_logs" {
  type        = bool
  default     = true
  description = "The flag is used to enable or disable flow logs accordingly"
}
