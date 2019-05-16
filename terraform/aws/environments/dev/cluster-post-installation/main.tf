terraform {
  required_version = ">= 0.11"
  backend "s3" {
    bucket = "terraform-monitoring-state-bucket-dev"
    key    = "central-monitoring-cluster-post-installation"
    region = "us-east-1"
  }
}


provider "aws" {
  region = "${var.region}"
  alias  = "post-deployment"
}


module "cluster-post-installation" {
  source = "../../../modules/cluster-post-installation"
  deployment_name = "${var.deployment_name}"
  account_id = "${var.account_id}"
  region = "${var.region}"
  tiller_version = "${var.tiller_version}"
  kubeconfig_dir = "${var.kubeconfig_dir}"
  providers = {
    aws = "aws.post-deployment"
  }
}
