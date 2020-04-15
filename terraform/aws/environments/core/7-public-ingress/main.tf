terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "terraform-cloud-monitoring-state-bucket-core"
    key    = "mattermost-cloud-public-ingress"
    region = "us-east-1"
  }
}

module "public-ingress" {
  source          = "../../../modules/public-ingress"
  deployment_name = var.deployment_name
  kubeconfig_dir  = var.kubeconfig_dir

}
