variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "transit_gateway_id" {
  type = string
}

variable "private_route_table_ids" {
  type = list(string)
}

variable "private_tgw_routes" {
  type = list(string)
}

variable "public_route_table_ids" {
  type = list(string)
}

variable "public_tgw_routes" {
  type = list(string)
}

variable "security_group_referencing_support" {
  description = "Security Group Referencing allows to specify other SGs as references, or matching criterion in inbound security rules to allow instance-to-instance traffic"
  type        = string
  default     = "enable"
}
