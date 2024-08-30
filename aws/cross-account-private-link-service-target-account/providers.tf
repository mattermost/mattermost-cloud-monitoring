terraform {
  required_version = ">= 1.6.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.41.0"
    }
  }
}

provider "aws" {
  alias  = "target"
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::${var.target_account_id}:role/TargetAccountTerraformRole" // Use the role created
  }
}

