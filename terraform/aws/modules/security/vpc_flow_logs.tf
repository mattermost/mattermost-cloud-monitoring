data "aws_vpcs" "vpcs" {}

data "aws_kms_alias" "s3" {
  name = "alias/aws/s3"
}

resource "aws_flow_log" "cloud_vpc" {
  count                = var.enable_flow_logs ? length(data.aws_vpcs.vpcs.ids) : 0
  log_destination      = "arn:aws:s3:::mm-flowlogs-${var.vpc_flow_logs_env}"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = element(data.aws_vpcs.vpcs.ids[*], count.index)
}

