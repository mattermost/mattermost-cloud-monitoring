data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {

  secret_manager_rds = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:rds-cluster-multitenant-*"

}
