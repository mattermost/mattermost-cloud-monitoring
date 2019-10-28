terraform {
  required_version = ">= 0.11"
  backend "s3" {
    bucket = "terraform-cloud-monitoring-state-bucket-staging"
    key    = "mattermost-central-command-control-post-installation"
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
  region = "${var.region}"
  tiller_version = "${var.tiller_version}"
  kubeconfig_dir = "${var.kubeconfig_dir}"
  grafana_tls_crt = "${var.grafana_tls_crt}"
  grafana_tls_key = "${var.grafana_tls_key}"
  prometheus_tls_crt = "${var.prometheus_tls_crt}"
  prometheus_tls_key = "${var.prometheus_tls_key}"
  kibana_tls_crt = "${var.kibana_tls_crt}"
  kibana_tls_key = "${var.kibana_tls_key}"
  providers = {
    aws = "aws.post-deployment"
  }
}
