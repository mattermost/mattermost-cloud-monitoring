data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket   = "terraform-cloud-monitoring-state-bucket-${var.environment}"
    key      = "${data.aws_region.current.name}/mattermost-central-command-control"
    region   = "us-east-1"
    role_arn = var.provider_role_arn
  }
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://charts.helm.sh/stable"
}

locals {
  conditional_dash_region = data.aws_region.current.name == "us-east-1" ? "" : "-${data.aws_region.current.name}"
  timestamp_now           = formatdate("YYYY-MM-DD-hh-mm", timestamp())
}

locals {
  db_identifier_read_replica = "${var.db_identifier}-read"
}

resource "aws_iam_access_key" "provisioner_user" {
  user = var.provisioner_users[0]
}
