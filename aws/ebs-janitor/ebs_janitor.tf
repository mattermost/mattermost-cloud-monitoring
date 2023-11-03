resource "aws_iam_role" "ebs_janitor_lambda_role" {
  name = "ebs_janitor_lambda_role"

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

resource "aws_iam_role_policy" "ebs_janitor_lambda_policy" {
  name = "ebs_janitor_lambda_policy"
  role = aws_iam_role.ebs_janitor_lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
            "ec2:DescribeVolumes",
            "ec2:DeleteVolume"
        ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRoleEBSJanitor" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.ebs_janitor_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRoleEBSJanitor" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.ebs_janitor_lambda_role.name
}

resource "aws_lambda_function" "ebs_janitor" {
  s3_bucket     = var.lambda_s3_bucket
  s3_key        = var.lambda_s3_key
  function_name = "ebs-janitor"
  role          = aws_iam_role.ebs_janitor_lambda_role.arn
  handler       = "bootstrap"
  timeout       = 120
  runtime       = "provided.al2"
  vpc_config {
    subnet_ids         = flatten(var.private_subnet_ids)
    security_group_ids = [aws_security_group.ebs_janitor_lambda_sg.id]
  }

  environment {
    variables = {
      MIN_SUBNET_FREE_IPs     = var.min_subnet_free_ips,
      MATTERMOST_ALERTS_HOOK  = var.mattermost_alerts_hook,
      JANITOR_DEBUG           = var.dryrun,
      JANITOR_EXPIRATION_DAYS = var.expiration_days
    }
  }
}

resource "aws_security_group" "ebs_janitor_lambda_sg" {
  name        = "${var.deployment_name}-ebs-janitor-lambda-sg"
  description = "EBS Janitor Lambda"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.deployment_name}-ebs-janitor-lambda-sg"
  }
}

resource "aws_cloudwatch_event_rule" "ebs_janitor" {
  name                = "ebs-janitor"
  description         = "Runs based on the schedule expression"
  schedule_expression = var.ebs_janitor_lambda_schedule
}

resource "aws_cloudwatch_event_target" "ebs_janitor" {
  rule      = aws_cloudwatch_event_rule.ebs_janitor.name
  target_id = "ebs-janitor"
  arn       = aws_lambda_function.ebs_janitor.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ebs_janitor" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ebs_janitor.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ebs_janitor.arn
}
