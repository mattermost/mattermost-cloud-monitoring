data "aws_vpcs" "vpcs" {}

data "aws_kms_alias" "s3" {
  name = "alias/aws/s3"
}

resource "aws_flow_log" "cloud_vpc" {
  count                = length(data.aws_vpcs.vpcs.ids)
  log_destination      = aws_s3_bucket.vpc_flow_logs.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = element(data.aws_vpcs.vpcs.ids[*], count.index)
}

resource "aws_s3_bucket" "vpc_flow_logs" {
  bucket = "mattermost-vpc-flow-logs-${var.environment}"
  region = "us-east-1"
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = data.aws_kms_alias.s3.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
