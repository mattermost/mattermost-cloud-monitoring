
variable "deployment_name" {}

variable "region" {}

variable "tiller_version" {}

variable "kubeconfig_dir" {}

variable "mattermost_cloud_image" {
  default = "mattermost/mattermost-cloud:latest"
}

variable "mattermost_cloud_ingress" {
  default = "mattermost-cloud.exemple.com"
}

variable "mattermost_cloud_secret_ssh_private" {}

variable "mattermost_cloud_secret_ssh_public" {}

variable "mattermost_cloud_secrets_aws_access_key" {}

variable "mattermost_cloud_secrets_aws_secret_key" {}

variable "mattermost_cloud_secrets_aws_region" {
  default ="us-east-1"
}

variable "mattermost_cloud_secrets_certificate_aws_arn" {}

variable "mattermost_cloud_secrets_database" {}

variable "mattermost_cloud_secrets_private_dns" {}

variable "mattermost_cloud_secrets_private_route53_id" {}

variable "mattermost_cloud_secrets_private_subnets" {}

variable "mattermost_cloud_secrets_public_subnets" {}

variable "mattermost_cloud_secrets_route53_id" {}

