data "aws_caller_identity" "current" {}

resource "aws_iam_role" "grafana_lambda_role" {
  name = "grafana_metrics_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "grafana_metrics_lambda_policy" {
  name = "grafana_metrics_lambda_policy"
  role = aws_iam_role.grafana_lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
            "elasticloadbalancing:DescribeAccountLimits",
            "elasticloadbalancing:DescribeLoadBalancers",
            "cloudwatch:PutMetricData",
            "ec2:DescribeVpcs",
            "rds:DescribeAccountAttributes",
            "servicequotas:GetServiceQuota",
            "autoscaling:DescribeAccountLimits",
            "ec2:DescribeAddresses"
        ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "grafana_access_role" {
  name = "grafana_access_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "grafana_access_policy" {
  name = "grafana_access_policy"
  role = aws_iam_role.grafana_access_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowReadingMetricsFromCloudWatch",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:DescribeAlarmsForMetric",
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:GetMetricData"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRoleGrafana" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.grafana_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRoleGrafana" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.grafana_lambda_role.name
}

resource "aws_lambda_function" "grafana_aws_metrics" {
  s3_bucket     = "releases.mattermost.com"
  s3_key        = "mattermost-cloud/grafana-aws-metrics/master/main.zip"
  function_name = "grafana-aws-metrics"
  role          = aws_iam_role.grafana_lambda_role.arn
  handler       = "main"
  timeout       = 120
  runtime       = "go1.x"
  vpc_config {
    subnet_ids         = flatten(var.private_subnet_ids)
    security_group_ids = [aws_security_group.grafana_lambda_sg.id]
  }

  environment {
    variables = {
      VPC_ID = var.vpc_id,
    }
  }
}

resource "aws_security_group" "grafana_lambda_sg" {
  name        = "${var.deployment_name}-grafana-lambda-sg"
  description = "Grafana AWS Metrics Lambda"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.deployment_name}-grafana-lambda-sg"
  }
}

resource "aws_cloudwatch_event_rule" "grafana_aws_metrics" {
  name                = "grafana-aws-metrics"
  description         = "Runs based on the schedule expression"
  schedule_expression = var.grafana_lambda_schedule
}

resource "aws_cloudwatch_event_target" "grafana_aws_metrics" {
  rule      = aws_cloudwatch_event_rule.grafana_aws_metrics.name
  target_id = "grafana-aws-metrics"
  arn       = aws_lambda_function.grafana_aws_metrics.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_grafana_aws_metrics" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.grafana_aws_metrics.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.grafana_aws_metrics.arn
}

resource "aws_iam_role_policy" "grafana-role-assume" {
  name = "grafana-role-assume-policy"
  role = var.worker-role

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "${aws_iam_role.grafana_access_role.arn}"
        }
    ]
}
EOF
}
