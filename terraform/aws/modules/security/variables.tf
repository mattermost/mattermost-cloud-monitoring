variable "environment" {}

variable "protected_resources" {}

variable "vpc_flow_logs_env" {}

variable "enable_flow_logs" {
  default = true
  type    = bool
}
