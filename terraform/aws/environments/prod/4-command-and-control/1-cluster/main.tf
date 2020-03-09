terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "terraform-cloud-monitoring-state-bucket-prod"
    key    = "mattermost-central-command-control"
    region = "us-east-1"
  }
}


provider "aws" {
  region = var.region
  alias  = "deployment"
}

module "cluster" {
  source                      = "../../../../modules/cluster"
  public_subnet_ids           = [var.public_subnet_ids]
  private_subnet_ids          = [var.private_subnet_ids]
  auth_private_subnet_ids     = [var.auth_private_subnet_ids]
  vpc_id                      = var.vpc_id
  auth_vpc_id                 = var.auth_vpc_id
  deployment_name             = "${var.deployment_name}-${var.environment}"
  instance_type               = var.instance_type
  max_size                    = var.max_size
  min_size                    = var.min_size
  desired_capacity            = var.desired_capacity
  cidr_blocks                 = var.cidr_blocks
  kubeconfig_dir              = var.kubeconfig_dir
  volume_size                 = var.volume_size
  prometheus_hosted_zoneid    = var.prometheus_hosted_zoneid
  installations_hosted_zoneid = var.installations_hosted_zoneid
  grafana_lambda_schedule     = var.grafana_lambda_schedule
  provisioner_server          = var.provisioner_server
  community_webhook           = var.community_webhook
  environment                 = var.environment
  api_gateway_vpc_endpoints   = var.api_gateway_vpc_endpoints
  eks_ami_id                  = var.eks_ami_id
  region                      = var.region
  key_name                    = var.key_name
  opsgenie_apikey             = var.opsgenie_apikey
  opsgenie_scheduler_team     = var.opsgenie_scheduler_team
  providers = {
    aws = aws.deployment
  }
}
