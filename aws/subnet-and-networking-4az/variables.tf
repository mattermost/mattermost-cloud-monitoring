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

variable "environment" {
  type = string
}

variable "teleport_cidr" {
  type = string
}

variable "command_and_control_private_subnet_cidrs" {
  type = list(string)
}

variable "vpn_cidrs" {
  type = list(string)
}

variable "deploy_cluster_parameter_group" {
  type = bool
}
