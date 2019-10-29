resource "aws_flow_log" "cloud_vpc" {
  count = "${length(var.vpc_ids)}"
  iam_role_arn    = "${aws_iam_role.vpc_flow_logs_role.arn}"
  log_destination = "${aws_cloudwatch_log_group.vpc_flow_logs_cw_group.arn}"
  traffic_type    = "ALL"
  vpc_id          = "${var.vpc_ids[count.index]}"
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs_cw_group" {
  name = "mattermost-cloud-${var.environment}-vpc-flow-logs"
}

resource "aws_iam_role" "vpc_flow_logs_role" {
  name = "VPCFlowLogsRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "VPCFlowLogsPolicy"
  role = "${aws_iam_role.vpc_flow_logs_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
