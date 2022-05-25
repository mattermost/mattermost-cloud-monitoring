data "aws_caller_identity" "current" {}

resource "aws_iam_role" "account_alerts_lambda_role" {
  name = "account_alerts_lambda_role"

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

resource "aws_iam_role_policy" "account_alerts_lambda_policy" {
  name = "account_alerts_lambda_policy"
  role = aws_iam_role.account_alerts_lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
            "ec2:DescribeVpcs",
            "ec2:DescribeSubnets"
        ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRoleAccountAlerts" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.account_alerts_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRoleAccountAlerts" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.account_alerts_lambda_role.name
}

resource "aws_lambda_function" "account_alerts" {
  s3_bucket     = "releases.mattermost.com"
  s3_key        = "mattermost-cloud/account-alerts/main/main.zip"
  function_name = "account-alerts"
  role          = aws_iam_role.account_alerts_lambda_role.arn
  handler       = "main"
  timeout       = 120
  runtime       = "go1.x"
  vpc_config {
    subnet_ids         = flatten(var.private_subnet_ids)
    security_group_ids = [aws_security_group.account_alerts_lambda_sg.id]
  }

  environment {
    variables = {
      MIN_SUBNET_FREE_IPs    = var.min_subnet_free_ips,
      MATTERMOST_ALERTS_HOOK = var.mattermost_alerts_hook,
    }
  }
}

resource "aws_security_group" "account_alerts_lambda_sg" {
  name        = "${var.deployment_name}-account-alerts-lambda-sg"
  description = "Account Alerts Lambda"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.deployment_name}-account-alerts-lambda-sg"
  }
}

resource "aws_cloudwatch_event_rule" "account_alerts" {
  name                = "account-alerts"
  description         = "Runs based on the schedule expression"
  schedule_expression = var.account_alerts_lambda_schedule
}

resource "aws_cloudwatch_event_target" "account_alerts" {
  rule      = aws_cloudwatch_event_rule.account_alerts.name
  target_id = "account-alerts"
  arn       = aws_lambda_function.account_alerts.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_account_alerts" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.account_alerts.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.account_alerts.arn
}
