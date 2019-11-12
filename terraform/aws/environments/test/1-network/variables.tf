variable "region" {
    default = "us-east-1"
    type = "string"
}

variable "shared_vpc_cidr" {
    default = ""
    type = "string"
}

variable "shared_vpc_private_subnets_cidrs" {
    default = [""]
    type = list(string)
}

variable "shared_vpc_public_subnets_cidrs" {
    default = [""]
    type = list(string)
}

variable "shared_vpc_azs" {
    default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
    type = list(string)
}

#This section is not used yet 
##########################################
variable "command_control_vpc_cidr" {
    default = ""
    type = "string"
}

variable "command_control_vpc_private_subnets_cidrs" {
    default = [""]
    type = list(string)
}

variable "command_control_vpc_public_subnets_cidrs" {
    default = [""]
    type = list(string)
}

variable "command_control_vpc_azs" {
    default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
    type = list(string)
}

variable "auth_vpc_cidr" {
    default = ""
    type = "string"
}

variable "auth_vpc_private_subnets_cidrs" {
    default = [""]
    type = list(string)
}

variable "auth_vpc_public_subnets_cidrs" {
    default = [""]
    type = list(string)
}

variable "auth_vpc_azs" {
    default = ["us-east-1a", "us-east-1b"]
    type = list(string)
}

##########################################
variable "environment" {
    default = "test"
    type = "string"
}

variable "private_dns_ips" {
    default = [""]
    type = list(string)
    description = "Private DNS IPs used by the Bind server"
}

variable "transit_gateway_id" {
    default = ""
    type = "string"
}

variable "ssh_key" {
    default = ""
    type = "string"
    description = "SSH key location used by the Bind server to install and configure bind9"
}

variable "ssh_key_public" {
    default = ""
    type = "string"
    description = "SSH keypair created for Bind server SSH"
}

variable "bind_cidr_blocks" {
    default = [""]
    type = list(string)
    description = "CIDRs to allow bind udp access"
}

variable "vpn_cidr" {
    default = [""]
    type = list(string)
    description = "VPN CIDR to allow bind SSH access"
}

variable "bind_server_ami" {
    default = "ami-04b9e92b5572fa0d1"
    type = string
    description = "The AMI of the Bind server, Ubuntu 18.04"
}

variable "private_hosted_zone_id" {
    default = ""
    type = string
    description = "The Private Hosted zone that will be associated with Shared Services for Bind server"
}

variable "transit_gtw_route_destination" {
    default = ""
    type = string
    description = "The destination of the transit gateway route table entry"
}
