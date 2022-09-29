data "aws_region" "current" {}

data "terraform_remote_state" "cnc_cluster" {
  backend = "s3"
  config = {
    bucket = "terraform-cloud-monitoring-state-bucket-${var.environment}"
    key    = "${data.aws_region.current.name}/mattermost-central-command-control"
    region = "us-east-1"
  }
}

locals {
  conditional_dash_region = data.aws_region.current.name == "us-east-1" ? "" : "-${data.aws_region.current.name}"
  timestamp_now           = formatdate("YYYY-MM-DD-hh-mm", timestamp())
}

locals {
  db_identifier_read_replica = "${var.awat_db_identifier}-read"
}
