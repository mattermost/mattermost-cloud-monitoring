variable "environment" {
  type        = string
  description = "The environment will be created"
}

variable "ami" {
  type        = string
  description = "Custom AMI to use for instances."
}

variable "instance_type" {
  type        = string
  description = "Type of instance to run the DNS servers"
  default     = "t3.nano"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets to run servers in"
}

variable "private_ips" {
  type        = list(string)
  description = "Private IP addresses of servers, which must be within the subnets specified in 'subnet_ids' (in the same order).  These are specified explicitly since it's desirable to be able to replace a DNS server without its IP address changing.  Our convention is to use the first unreserved address in the subnet (which is to say, the '+4' address)."
}

variable "name" {
  type        = string
  description = "Name prefix of the instances (will have server number appended).  One of 'name' or 'names' may be specified."
  default     = "dns"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID runs in"
}

variable "vpn_cidr" {
  type        = list(string)
  description = "The VPN CIDR block to allow access"
}
variable "teleport_cidr" {
  type        = list(string)
  description = "The Teleport CIDR block to allow access"
}

variable "cidr_blocks" {
  type        = list(string)
  description = "The CIDR block to allow network traffic"
}

variable "ssh_key_public" {
  type        = string
  description = "The contect of the SSH public key"
}

variable "volume_size" {
  type        = number
  description = "The size of the volume for DNS Bind Servers"
  default     = 8
}

variable "volume_type" {
  type        = string
  description = "The type of the volume for DNS Bind Servers"
  default     = "gp2"
}

variable "hosts_list" {
  type        = list(string)
  description = "The list of bind servers hosts"
  default     = []
}
