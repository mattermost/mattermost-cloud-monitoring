variable "deployment_name" {
  type        = string
  description = "The name of the deployment name which be used for launch configuration"
}

variable "atlantis_deployment_name" {
  type        = string
  description = "The name of the deployment name which be used for ASG"
}

variable "private_hosted_zoneid" {
  type        = string
  description = "The ID of the Route53 private hosted zone"
}

variable "ami_id" {
  type        = string
  description = "The AMI ID which will be used for the launch configuration where will deploy the Atlantis UI"
}

variable "instance_type" {
  type        = string
  description = "The instance type will be used for launch configuration and ASG"
}

variable "key_name" {
  type        = string
  description = "The SSH key name to use for accessing the ASG nodes"
}

variable "subnet_id" {
  type        = string
  description = "The subnet ID for the ASG and the VPC zones"
}

variable "environment" {
  type        = string
  description = "The name of the environment which will deploy to and will be added as a tag"
}

variable "desired_capacity" {
  type        = number
  description = "The desired capacity of ASG"
}

variable "min_size" {
  type        = number
  description = "The minimum number of nodes for ASG"
}

variable "max_size" {
  type        = number
  description = "The maximum number of nodes for ASG"
}

variable "volume_size" {
  type        = string
  description = "The root block device volume size for launch configuration of Atlantis UI"
}

variable "security_groups" {
  type        = list(string)
  description = "The attached security group ID list for launch configuration of Atlantis UI"
}
