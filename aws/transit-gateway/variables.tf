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

variable "public_route_table_ids" {
  type = list(string)
}

variable "transit_gtw_route_destination" {
  type = string
}

variable "transit_gtw_route_destination_security" {
  type = string
}

variable "transit_gtw_route_destination_gitlab" {
  type = string
}
