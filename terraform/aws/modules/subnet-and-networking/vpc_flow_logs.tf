data "aws_caller_identity" "current" {}

resource "aws_flow_log" "provisioning_vpc" {
  for_each = toset(var.vpc_cidrs)
  
  iam_role_arn    = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/VPCFlowLogsRole"
  log_destination = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/mattermost-cloud-${var.environment}-vpc-flow-logs"
  traffic_type    = "ALL"
  vpc_id          = data.aws_vpc.vpc_ids[each.value]["id"]
}
