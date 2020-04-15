terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "terraform-cloud-monitoring-state-bucket-staging"
    key    = "mattermost-network-provisioning-vpcs"
    region = "us-east-1"
  }
}


provider "aws" {
  region = var.region
  alias  = "deployment"
}

module "vpc_setup" {
  source               = "../../../../modules/vpc-setup"
  environment          = var.environment
  vpc_cidrs            = var.vpc_cidrs
  vpc_azs              = var.vpc_azs
  name                 = "mattermost-cloud-${var.environment}-provisioning"
  enable_dns_hostnames = true
  tags = {
    Owner       = "cloud-team"
    Terraform   = "true"
    Environment = var.environment
    Purpose     = "provisioning"
  }
  providers = {
    aws = "aws.deployment"
  }
}
