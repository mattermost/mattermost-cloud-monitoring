variable "vpc_id" {}

variable "auth_vpc_id" {}

variable "public_subnet_ids" {}

variable "private_subnet_ids" {}

variable "auth_private_subnet_ids" {}

variable "deployment_name" {}

variable "instance_type" {}

variable "max_size" {}

variable "min_size" {}

variable "desired_capacity" {}

variable "cidr_blocks" {}

variable "kubeconfig_dir" {}

variable "volume_size" {}

variable "prometheus_hosted_zoneid" {}

variable "installations_hosted_zoneid" {}

variable "grafana_lambda_schedule" {}

variable "provisioner_server" {}

variable "community_webhook" {}

variable "environment" {}

variable "api_gateway_vpc_endpoints" {}

variable "region" {}

variable "eks_ami_id" {}

variable "key_name" {}

variable "mattermost_hook" {}

variable "opsgenie_apikey" {}

variable "opsgenie_scheduler_team" {}
