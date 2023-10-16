variable "vpc_cidrs" {
  type = list(string)
}

variable "vpc_azs" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "name" {
  type = string
}

variable "transit_gateway_id" {
  type = string
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

variable "teleport_cidr" {
  type = list(string)
}

variable "command_and_control_private_subnet_cidrs" {
  type = list(string)
}

variable "vpn_cidrs" {
  type = list(string)
}

variable "gitlab_cidr" {
  type        = list(any)
  description = "The gitlab CIDR"
}

variable "multi_route_table_deployment" {
  type        = bool
  description = "This will defined whether a dedicated route table per subnet will be created. multi_route_table_deployment and single_route_table_deployment cannot be both set to true"
}

variable "single_route_table_deployment" {
  type        = bool
  description = "This will defined whether a single route table for all subnets will be created. multi_route_table_deployment and single_route_table_deployment cannot be both set to true"
}

variable "vpc_endpoint_service" {
  type        = string
  description = "This the VPC endpoint service, for example com.amazonaws.us-east-1.s3"
}
