terraform {
  required_version = ">= 1.1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = ">= 3.55"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}
