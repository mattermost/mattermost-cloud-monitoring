variable "ami" {
  description = "Custom AMI to use for instances."
  type        = string
}

variable "instance_type" {
  description = "Type of instance to run the DNS servers"
  default     = "t3.nano"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets to run servers in"
  type        = list(string)
}

variable "private_ips" {
  description = "Private IP addresses of servers, which must be within the subnets specified in 'subnet_ids' (in the same order).  These are specified explicitly since it's desirable to be able to replace a DNS server without its IP address changing.  Our convention is to use the first unreserved address in the subnet (which is to say, the '+4' address)."
  type        = list(string)
}

variable "ssh_key" {
  description = "File path to the private key for SSH"
  type        = string
}

variable "name" {
  description = "Name prefix of the instances (will have server number appended).  One of 'name' or 'names' may be specified."
  default     = "dns"
  type        = string
}

variable "vpc_id" {}

variable "vpn_cidr" {}

variable "cidr_blocks" {}

variable "environment" {}

variable "ssh_key_public" {}

variable "teleport_cidr" {}

variable "volume_size" {
  description = "The size of the volume for DNS Bind Servers"
  default     = 8
  type        = number
}

variable "volume_type" {
  description = "The type of the volume for DNS Bind Servers"
  default     = "gp2"
  type        = string
}

