variable "ami_id" {
  description = "AMI ID to be used for the instance"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be deployed"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID to be used"
  type        = string
}

variable "nlb_name" {
  description = "Name of the Network Load Balancer"
  type        = string
}

variable "listener_port" {
  description = "Listener port for NLB"
  type        = number
  default     = 80
}

variable "target_group_name" {
  description = "Name of the target group for NLB"
  type        = string
}

variable "allowed_principals" {
  description = "List of AWS principals allowed to access the endpoint service"
  type        = list(string)
}
