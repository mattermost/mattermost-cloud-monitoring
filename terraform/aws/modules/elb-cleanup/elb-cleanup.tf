data "aws_caller_identity" "current" {}

resource "aws_iam_role" "elb_cleanup_lambda_role" {
  name = "elb_cleanup_lambda_role"

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

resource "aws_iam_role_policy" "elb_cleanup_lambda_policy" {
  name = "elb_cleanup__lambda_policy"
  role = aws_iam_role.elb_cleanup_lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
            "elasticloadbalancing:*"
        ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRoleELBCleanup" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.elb_cleanup_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRoleELBCleanup" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.elb_cleanup_lambda_role.name
}

resource "aws_lambda_function" "elb_cleanup" {
  s3_bucket     = "mshahid-tf-dev"
  s3_key        = "mattermost-cloud/elb-cleanup/master/main.zip"
  function_name = "elb-cleanup"
  role          = aws_iam_role.elb_cleanup_lambda_role.arn
  handler       = "main"
  timeout       = 120
  runtime       = "go1.x"
  vpc_config {
    subnet_ids         = flatten(var.private_subnet_ids)
    security_group_ids = [aws_security_group.elb_cleanup_lambda_sg.id]
  }

  # environment {
  #   variables = {
  #     MIN_SUBNET_FREE_IPs    = var.min_subnet_free_ips,
  #     MATTERMOST_ALERTS_HOOK = var.mattermost_alerts_hook,
  #   }
  # }
}

resource "aws_security_group" "elb_cleanup_lambda_sg" {
  name        = "${var.deployment_name}-elb-cleanup-lambda-sg"
  description = "ELB Cleanp Lambda"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.deployment_name}-elb-cleanup-lambda-sg"
  }
}

resource "aws_cloudwatch_event_rule" "elb_cleanup" {
  name                = "elb-cleanup"
  description         = "Runs based on the schedule expression"
  schedule_expression = var.elb_cleanup_lambda_schedule
}

resource "aws_cloudwatch_event_target" "elb_cleanup" {
  rule      = aws_cloudwatch_event_rule.elb_cleanup.name
  target_id = "elb-cleanup"
  arn       = aws_lambda_function.elb_cleanup.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_elb_cleanup" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.elb_cleanup.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.elb_cleanup.arn
}
