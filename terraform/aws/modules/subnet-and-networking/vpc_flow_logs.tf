
resource "aws_flow_log" "provisioning_vpc" {
  for_each = toset(var.vpc_cidrs)
  
  iam_role_arn    = "arn:aws:iam::${var.account_id}:role/VPCFlowLogsRole"
  log_destination = "arn:aws:logs:${var.region}:${var.account_id}:log-group:/mattermost-cloud-${var.environment}-vpc-flow-logs"
  traffic_type    = "ALL"
  vpc_id          = data.aws_vpc.vpc_ids[each.value]["id"]
}
