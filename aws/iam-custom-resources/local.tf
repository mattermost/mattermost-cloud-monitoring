data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {

  secret_manager_rds = "arn:aws:secretsmanage:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret/rds-cluster-multitenant-*"
}

output "name" {
  value = local.secret_manager_rds
}
