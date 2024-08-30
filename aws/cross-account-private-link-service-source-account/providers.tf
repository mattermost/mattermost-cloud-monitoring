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
  alias  = "source"
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::${var.source_account_id}:role/SourceAccountTerraformRole" // Use the role created
  }
}

