terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "terraform-cloud-monitoring-state-bucket-test"
    key    = "mattermost-elasticsearch"
    region = "us-east-1"
  }
}


provider "aws" {
  region = var.region
  alias  = "deployment"
}

module "elasticsearch" {
  source                     = "../../../../modules/elasticsearch"
  environment                = var.environment
  domain_name                = "mattermost-cloud-es-${var.environment}"
  es_version                 = var.es_version
  vpn_cidr                   = var.vpn_cidr
  mattermost_network         = var.mattermost_network
  vpc_id                     = var.vpc_id
  private_subnet_ids         = var.private_subnet_ids
  es_instance_type           = var.es_instance_type
  es_volume_size             = var.es_volume_size
  instance_count             = var.instance_count
  dedicated_master_type      = var.dedicated_master_type
  dedicated_master_threshold = var.dedicated_master_threshold
  es_zone_awareness          = var.es_zone_awareness
  es_zone_awareness_count    = var.es_zone_awareness_count
  private_hosted_zoneid      = var.private_hosted_zoneid
  providers = {
    aws = "aws.deployment"
  }
}
