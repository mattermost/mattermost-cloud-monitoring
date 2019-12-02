variable "vpc_id" {
  default = ""
  type    = "string"

}

variable "public_subnet_ids" {
  default = [""]
  type    = list(string)
}

variable "private_subnet_ids" {
  default = [""]
  type    = list(string)
}

variable "deployment_name" {
  default = "mattermost-central-command-control"
  type    = "string"
}

variable "instance_type" {
  default = "t2.large"
  type    = "string"
}

variable "max_size" {
  default = "8"
  type    = "string"
}

variable "min_size" {
  default = "6"
  type    = "string"
}

variable "desired_capacity" {
  default = "6"
  type    = "string"
}

variable "region" {
  default = "us-east-1"
  type    = "string"
}

variable "account_id" {
  default = ""
  type    = "string"
}

variable "environment" {
  default = "staging"
  type    = "string"
}

variable "cidr_blocks" {
  default     = [""]
  type        = list(string)
  description = "CIDR to allow inbound cluster access"
}

variable "kubeconfig_dir" {
  default = "$HOME/generated"
  type    = "string"
}

variable "volume_size" {
  default = "50"
  type    = "string"
}

variable "private_hosted_zoneid" {
  default = ""
  type    = "string"
}

variable "grafana_lambda_schedule" {
  default = "rate(1 hour)"
  type    = "string"
}

variable "provisioner_server" {
  default = ""
  type    = "string"
}

variable "community_webhook" {
  default = ""
  type    = "string"
}

variable "api_gateway_vpc_endpoints" {
  default     = [""]
  type        = list(string)
  description = "VPC endpoints of mattermost-cloud-core and mattermost-core VPCs"
}

variable "eks_ami_id" {
  default     = ""
  type        = "string"
  description = "Custom AMI ID to use for EKS workers"
}
