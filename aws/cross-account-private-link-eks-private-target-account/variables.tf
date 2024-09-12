variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster and proxy will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets used by the EKS cluster"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for the proxy instance"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster to create or validate"
  type        = string
}

variable "security_group_ids" {
  description = "Security Groups for the EKS cluster"
  type        = list(string)
}

variable "proxy_security_group_ids" {
  description = "Security Groups for the proxy instance"
  type        = list(string)
}

variable "create_private_endpoint" {
  description = "Flag to indicate if the EKS cluster should have a private endpoint only"
  type        = bool
  default     = true
}

variable "nlb_name" {
  description = "Name of the Network Load Balancer"
  type        = string
}

variable "listener_port" {
  description = "Listener port for NLB"
  type        = number
  default     = 443
}

variable "target_group_name" {
  description = "Name of the target group for NLB"
  type        = string
}

variable "allowed_principals" {
  description = "List of AWS principals allowed to access the endpoint service"
  type        = list(string)
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "proxy_subnet_id" {
  description = "Subnet ID where the instance will be deployed"
  type        = string
}

variable "check_nlb" {
  type    = bool
  default = false
}

variable "check_eks" {
  type    = bool
  default = false
}
