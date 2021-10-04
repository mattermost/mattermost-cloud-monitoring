data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket = "terraform-cloud-monitoring-state-bucket-${var.environment}"
    key    = "mattermost-cloud-gitlab"
    region = "us-east-1"
  }
}

locals {
  timestamp_now = formatdate("YYYY-MM-DD-hh-mm", timestamp())
}
