terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "terraform-cloud-monitoring-state-bucket-dev"
    key    = "mattermost-network-provisioning-subnets"
    region = "us-east-1"
  }
}


provider "aws" {
  region = var.region
  alias  = "deployment"
}


module "subnet_setup" {
  source                        = "../../../../modules/subnet-and-networking"
  vpc_cidrs                     = var.vpc_cidrs
  vpc_azs                       = var.vpc_azs
  environment                   = var.environment
  name                          = "mattermost-cloud-${var.environment}-provisioning"
  transit_gateway_id            = var.transit_gateway_id
  transit_gtw_route_destination = var.transit_gtw_route_destination
  region                        = var.region
  tags = {
    Owner       = "cloud-team"
    Terraform   = "true"
    Environment = var.environment
    Purpose     = "provisioning"
  }
}
