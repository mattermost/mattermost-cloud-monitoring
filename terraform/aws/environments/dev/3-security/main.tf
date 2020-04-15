terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "terraform-cloud-monitoring-state-bucket-dev"
    key    = "mattermost-security"
    region = "us-east-1"
  }
}


provider "aws" {
  region = var.region
  alias  = "deployment"
}

module "security" {
  source      = "../../../modules/security"
  environment = var.environment
  providers = {
    aws = "aws.deployment"
  }
}
