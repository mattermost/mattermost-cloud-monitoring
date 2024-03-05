data "aws_region" "current" {}

data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket = "terraform-cloud-monitoring-state-bucket-${var.environment}"
    key    = "${data.aws_region.current.name}/mattermost-central-command-control"
    region = "us-east-1"
    assume_role = {
      role_arn = var.provider_role_arn
    }
  }
}

locals {
  timestamp_now = formatdate("YYYY-MM-DD-hh-mm", timestamp())
}

resource "aws_iam_access_key" "provisioner_user" {
  user = var.provisioner_users[0]
}
