variable "vpc_id" {
  description = "The VPC ID of the database cluster"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "instance_type" {
  description = "The instance type of the ec2 instance"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  type = string
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "subnet_id" {
  type = string
}

variable "associate_public_ip_address" {
  type    = bool
  default = true
}

variable "source_dest_check" {
  type    = bool
  default = true
}

variable "disable_api_termination" {
  type    = bool
  default = true
}

variable "monitoring" {
  type    = bool
  default = false
}

variable "volume_type" {
  type    = string
  default = "gp3"
}

variable "volume_size" {
  type    = number
  default = 20
}

variable "delete_on_termination" {
  type    = bool
  default = true
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "The IDs of the security groups that will be assigned to the node"
}

variable "cpu_credits" {
  type    = string
  default = "unlimited"
}

variable "key_name" {
  type = string
}

variable "public_key" {
  type = string
}

variable "stitch_ips" {
  type = list(string)
}
