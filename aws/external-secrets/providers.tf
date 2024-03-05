terraform {
  required_version = ">= 1.5.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.61.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 4.25.0"
    }
  }
}
