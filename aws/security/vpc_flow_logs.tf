data "aws_vpcs" "vpcs" {}

resource "aws_flow_log" "cloud_vpc" {
  for_each             = var.enable_flow_logs ? { for vpc_id in data.aws_vpcs.vpcs.ids : vpc_id => vpc_id } : {}
  log_destination      = "arn:aws:s3:::mm-flowlogs-${var.vpc_flow_logs_env}"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = each.key
}
