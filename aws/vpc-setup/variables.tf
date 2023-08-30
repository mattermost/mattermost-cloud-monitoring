variable "vpc_cidrs" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "name" {
  type = string
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "tags" {
  type = map(string)
}

variable "deploy_node_policy" {
  type = bool
}

variable "deploy_rds_enhanced_monitoring_role" {
  type = bool
}

variable "custom_vpc_kms_keys" {
  type    = map(string)
  default = {}
}
