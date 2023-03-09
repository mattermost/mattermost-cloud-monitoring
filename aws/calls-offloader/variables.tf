variable "instance_type" {
  description = "Instance type for the call offloader"
  type        = string
  default     = "c5.2xlarge"
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

variable "vpc_worker_sg_id" {
  description = "Security Group ID for the worker nodes in the VPC"
  type        = list(string)
}
