terraform {
  required_version = ">= 1.6"
  backend "s3" {
    bucket = "terraform-cloud-monitoring-state-bucket-dev"
    key    = "us-east-1/andre-eks-customer"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.41.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.1"
    }
  }
}
