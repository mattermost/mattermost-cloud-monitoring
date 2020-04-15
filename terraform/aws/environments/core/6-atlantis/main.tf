terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "terraform-cloud-monitoring-state-bucket-core"
    key    = "mattermost-cloud-atlantis"
    region = "us-east-1"
  }
}

module "atlantis" {
  source                = "../../../modules/atlantis"
  deployment_name       = var.deployment_name
  kubeconfig_dir        = var.kubeconfig_dir
  org_whitelist         = var.org_whitelist
  gitlab_user           = var.gitlab_user
  gitlab_token          = var.gitlab_token
  gitlab_webhook_secret = var.gitlab_webhook_secret
  gitlab_hostname       = var.gitlab_hostname
  atlantis_hostname     = var.atlantis_hostname
  private_hosted_zoneid = var.private_hosted_zoneid
  aws_secretname        = var.aws_secretname
}
