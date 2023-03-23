variable "route_table_ids" {
  description = "The ID of the routing tables"
  type        = list(string)
}

variable "transit_gateway_id" {
  description = "The ID of an EC2 Transit Gateway"
  type        = string
}

variable "destination_cidr_block" {
  description = "The destination CIDR block"
  type        = string
}

variable "timeout_create" {
  description = "The destination CIDR block"
  type        = string
  default     = "5m"
}
