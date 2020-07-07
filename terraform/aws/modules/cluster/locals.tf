data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  provider_role_arn = var.provider_role_arn == "" ? data.aws_caller_identity.current.arn : var.provider_role_arn
}
