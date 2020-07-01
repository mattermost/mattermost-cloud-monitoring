data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket = "terraform-cloud-monitoring-state-bucket-${var.environment}"
    key    = "${data.aws_region.current.name}/mattermost-central-command-control"
    region = "us-east-1"
  }
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.deployment_name
}

data "aws_eks_cluster" "cluster" {
  name = var.deployment_name
}

locals {
  conditional_dash_region = data.aws_region.current.name == "us-east-1" ? "" : "-${data.aws_region.current.name}"
  timestamp_now = formatdate("YYYY-MM-DD-hh-mm", timestamp())
}
