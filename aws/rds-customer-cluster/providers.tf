terraform {
  required_version = ">= 1.6.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.2"
    }
  }
}

provider "aws" {
  alias = "primary"
}

provider "aws" {
  alias = "secondary"
}
