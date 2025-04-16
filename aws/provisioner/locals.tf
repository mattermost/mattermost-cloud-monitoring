data "aws_region" "current" {}

data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket = "terraform-cloud-monitoring-state-bucket-${var.environment}"
    key    = "${data.aws_region.current.name}/mattermost-central-command-control"
    region = "us-east-1"
  }
}

locals {
  timestamp_now = formatdate("YYYY-MM-DD-hh-mm", timestamp())
}

resource "aws_iam_access_key" "provisioner_user" {
  count = length(var.provisioner_users) > 0 ? 1 : 0
  user  = var.provisioner_users[count.index]
}
