data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

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
  region = data.aws_region.current.name
  assume_role {
    role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TargetAccountTerraformRole" // Replace with appropriate role
  }
}


