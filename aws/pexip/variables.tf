variable "name" {
  type    = string
  default = "pexip"
}

variable "public_subnet_id" {
  type        = string
  description = "A public subnet ID"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the vpc for the security group of Pexip"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "The Cloudflare zone ID provided"
}

variable "conference_cloudflare_record_name" {
  type        = string
  description = "The DNS name for the Pexip conference node"
}

variable "management_cloudflare_record_name" {
  type        = string
  description = "The DNS name for the Pexip management node"
}

variable "management_private_ips" {
  type        = list(string)
  description = "List of the private IPs of the Pexip management node"
}

variable "conference_private_ips" {
  type        = list(string)
  description = "List of the private IPs of the Pexip Conference node"
}

variable "vpn_ips" {
  type        = list(string)
  description = "List of the IPs for the VPN"
}

variable "official_pexip_management_ec2_ami" {
  default     = "ami-0dd1e9ce5c9029446"
  type        = string
  description = "The official Pexip AMI for management node"
}

variable "official_pexip_conference_ec2_ami" {
  default     = "ami-0ddd16b36dc9f4229"
  type        = string
  description = "The official Pexip AMI for conference node"
}

variable "custom_management_ec2_ami" {
  type        = string
  description = "Customized with MM configuration Pexip AMI for management node"
}

variable "custom_conference_ec2_ami" {
  type        = string
  description = "Customized with MM configuration Pexip AMI for conference node"
}

variable "management_ec2_type" {
  type        = string
  description = "The EC2 instance type for Pexip management node"
}

variable "conference_ec2_type" {
  type        = string
  description = "The EC2 instance type for Pexip conference node"
}

variable "ec2_key_pair" {
  type        = string
  description = "The key pair that will be used for ssh to EC2 instances of Pexip nodes"
}

variable "initial_configuration" {
  description = "A boolean variable to control the initial configuration of Pexip setup, when true official AMI will be deployed and key-pairs will be added to EC2 nodes"
  type        = bool
  default     = true
}
