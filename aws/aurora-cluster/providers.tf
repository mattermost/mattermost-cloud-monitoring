terraform {
  required_version = ">= 1.1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = ">= 3.55"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}
