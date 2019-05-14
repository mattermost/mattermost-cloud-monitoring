terraform {
  required_version = ">= 0.11"
  backend "s3" {
    bucket = "terraform-monitoring-state-bucket-dev"
    key    = "central-monitoring-deployment-iam"
    region = "us-east-1"
  }
}

provider "aws" {
  region     = "us-east-1"
}

module "deployment-role" {
  source = "../../../modules/deployment-role"
  deployment_name = "${var.deployment_name}"
  environment = "${var.environment}"
  account_id = "${var.account_id}"
}