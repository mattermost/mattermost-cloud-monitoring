variable "vpc_id" {
  default = ""
  type    = string

}

variable "auth_vpc_id" {
  default = ""
  type    = string
}

variable "public_subnet_ids" {
  type    = list(string)
  default = [""]
}

variable "private_subnet_ids" {
  type    = list(string)
  default = [""]
}

variable "auth_private_subnet_ids" {
  default = [""]
  type    = list(string)
}

variable "deployment_name" {
  default = "mattermost-central-command-control"
  type    = string
}

variable "instance_type" {
  default = "t2.large"
  type    = string
}

variable "max_size" {
  default = "8"
  type    = string
}

variable "min_size" {
  default = "6"
  type    = string
}

variable "desired_capacity" {
  default = "6"
  type    = string
}

variable "region" {
  default = "us-east-1"
  type    = string
}

variable "account_id" {
  default = ""
  type    = string
}

variable "environment" {
  default = "dev"
  type    = string
}

variable "cidr_blocks" {
  default     = [""]
  type        = list(string)
  description = "CIDR to allow inbound cluster access"
}

variable "kubeconfig_dir" {
  default = "$HOME/generated"
  type    = string
}

variable "volume_size" {
  default = "50"
  type    = string
}

variable "private_hosted_zoneid" {
  default = ""
  type    = string
}

variable "grafana_lambda_schedule" {
  default = "rate(4 hours)"
  type    = string
}

variable "provisioner_server" {
  default = ""
  type    = string
}

variable "community_webhook" {
  default     = ""
  type        = string
  description = "The mattermost webhook to post the messages"
}

variable "api_gateway_vpc_endpoints" {
  default     = [""]
  type        = list(string)
  description = "VPC endpoints of mattermost-cloud-core, mattermost-core, mattermost and mattermost-test VPCs"
}

variable "eks_ami_id" {
  default     = ""
  type        = string
  description = "Custom AMI ID to use for EKS workers"
}

variable "key_name" {
  default     = ""
  type        = string
  description = "The command and control cluster node ssh key"
}

variable "opsgenie_apikey" {
  default     = ""
  type        = string
  description = "The opsgenie apikey"
}

variable "opsgenie_scheduler_team" {
  default     = ""
  type        = string
  description = "The opsgenie scheduler team uuid"
}
