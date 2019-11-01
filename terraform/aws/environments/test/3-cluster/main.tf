terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "terraform-cloud-monitoring-state-bucket-test"
    key    = "mattermost-central-command-control"
    region = "us-east-1"
  }
}


provider "aws" {
  region = var.region
  alias  = "deployment"
}

module "cluster" {
  source = "../../../modules/cluster"
  public_subnet_ids = [var.public_subnet_ids]
  private_subnet_ids = [var.private_subnet_ids]
  vpc_id      = var.vpc_id
  deployment_name = var.deployment_name
  instance_type = var.instance_type
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity
  cidr_blocks = var.cidr_blocks
  kubeconfig_dir = var.kubeconfig_dir
  account_id = var.account_id
  volume_size = var.volume_size
  private_hosted_zoneid = var.private_hosted_zoneid
  grafana_lambda_schedule = var.grafana_lambda_schedule
  provisioner_server = var.provisioner_server
  community_webhook = var.community_webhook
  environment = var.environment
  api_gateway_vpc_endpoints = var.api_gateway_vpc_endpoints
  region = var.region
  providers = {
    aws = "aws.deployment"
  }
}
