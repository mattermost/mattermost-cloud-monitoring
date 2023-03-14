variable "environment" {
  type        = string
  description = "The name of the environment which will deploy to and will be added as a tag"
}

variable "instance_type" {
  description = "Instance type for the call offloader"
  type        = string
  default     = "c5.xlarge"
}

variable "ami_id" {
  description = "AMI to use for the call offloader"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to use for the call offloader"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to use for the call offloader"
  type        = string
}

variable "teleport_cidr" {
  description = "The Teleport CIDR for calls offloader access"
  type        = list(string)
}

variable "cloud_vpn_cidr" {
  description = "The Cloud VPN CIDR for calls offloader access"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "The VPC CIDR for calls offloader access and load balancer access"
  type        = list(string)
}

variable "vpc_worker_sg_id" {
  description = "Security Group ID for the worker nodes in the VPC"
  type        = list(string)
}

variable "public_key" {
  description = "Public key to use for the call offloader"
  type        = string
}

variable "min_size" {
  description = "Minimum number of instances to run"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Minimum number of instances to run"
  type        = number
  default     = 2
}

variable "private_hosted_zoneid" {
  description = "Private Hosted Zone ID for the VPC"
  type        = string
}
