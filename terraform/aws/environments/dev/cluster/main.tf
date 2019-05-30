terraform {
  required_version = ">= 0.11"
  backend "s3" {
    bucket = "terraform-cloud-monitoring-state-bucket-dev"
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
  public_subnet_ids = ["${var.public_subnet_ids}"]
  private_subnet_ids = ["${var.private_subnet_ids}"]
  vpc_id      = "${var.vpc_id}"
  deployment_name = "${var.deployment_name}"
  instance_type = "${var.instance_type}"
  max_size = "${var.max_size}"
  min_size = "${var.min_size}"
  desired_capacity = "${var.desired_capacity}"
  cidr_blocks = "${var.cidr_blocks}"
  kubeconfig_dir = "${var.kubeconfig_dir}"
  account_id = "${var.account_id}"
  volume_size = "${var.volume_size}"
  providers = {
    aws = "aws.deployment"
  }
}
