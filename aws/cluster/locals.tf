data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  extra_auth_config_provider = var.provider_role_arn == "" ? "" : local.provider_auth_config
  provider_auth_config       = <<YAML

  - rolearn: "${var.provider_role_arn}"
    username: admin
    groups:
      - system:masters
  YAML
}
