provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user_id" {
  value = data.aws_caller_identity.current.user_id
}
