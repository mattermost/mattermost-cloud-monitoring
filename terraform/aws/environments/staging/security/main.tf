terraform {
  required_version = ">= 0.11"
  backend "s3" {
    bucket = "terraform-cloud-monitoring-state-bucket-staging"
    key    = "mattermost-security"
    region = "us-east-1"
  }
}


provider "aws" {
  region = "${var.region}"
  alias  = "deployment"
}

module "security" {
  source = "../../../modules/security"
  environment = "${var.environment}"
  vpc_ids = "${var.vpc_ids}"
  providers = {
    aws = "aws.deployment"
  }
}
