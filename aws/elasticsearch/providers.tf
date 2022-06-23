terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws",
      version = ">= 3.55.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.0.0"
    }
  }
}
