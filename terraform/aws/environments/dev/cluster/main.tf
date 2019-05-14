terraform {
  required_version = ">= 0.11"
  backend "s3" {
    bucket = "terraform-monitoring-state-bucket-dev"
    key    = "central-monitoring-cluster"
    region = "us-east-1"
  }
}


provider "aws" {
  region = "${var.region}"
  alias  = "deployment"
}

module "cluster" {
  source = "../../../modules/cluster"
  subnet_ids = ["${var.subnet_ids}"]
  vpc_id      = "${var.vpc_id}"
  deployment_name = "${var.deployment_name}"
  instance_type = "${var.instance_type}"
  max_size = "${var.max_size}"
  min_size = "${var.min_size}"
  desired_capacity = "${var.desired_capacity}"
  cidr_blocks = "${var.cidr_blocks}"
  providers = {
    aws = "aws.deployment"
  }
}

