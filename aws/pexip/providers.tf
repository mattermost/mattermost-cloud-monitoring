terraform {
  required_version = ">= 1.6.3"
  backend "s3" {
    bucket = "terraform-cloud-monitoring-state-bucket-test"
    key    = "us-east-1/mattermost-pexip"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.41.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.25.0"
    }
  }
}
