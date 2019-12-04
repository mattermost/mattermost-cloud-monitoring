terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "terraform-cloud-monitoring-state-bucket-prod"
    key    = "mattermost-central-command-control-route53-registration"
    region = "us-east-1"
  }
}


provider "aws" {
  region = var.region
  alias  = "route53-registration"
}


module "route53-registration" {
  source = "../../../../modules/route53-registration"
  deployment_name = "${var.deployment_name}-prod"
  kubeconfig_dir = var.kubeconfig_dir
  private_hosted_zoneid = var.private_hosted_zoneid
  public_hosted_zoneid = var.public_hosted_zoneid
  providers = {
    aws = aws.route53-registration
  }
}
