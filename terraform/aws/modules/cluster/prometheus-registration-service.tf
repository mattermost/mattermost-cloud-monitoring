resource "aws_iam_role" "lambda_role" {
  name = "iam_for_lambda"

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

resource "aws_iam_role_policy" "EKSAccess" {
  name = "test_policy"
  role = aws_iam_role.lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:GetCallerIdentity",
        "eks:DescribeCluster",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonRoute53ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53ReadOnlyAccess"
  role       = aws_iam_role.lambda_role.name
}


resource "aws_lambda_function" "prometheus_registration" {
  filename         = "../../../../../../prometheus-dns-registration-service/main.zip"
  function_name    = "prometheus-dns-registration-service"
  role             = aws_iam_role.lambda_role.arn
  handler          = "main"
  timeout          = 120
  source_code_hash = filebase64sha256("../../../../../../prometheus-dns-registration-service/main.zip")
  runtime          = "go1.x"
  vpc_config {
    subnet_ids         = flatten([var.private_subnet_ids])
    security_group_ids = [aws_security_group.lambda-sg.id]
  }

  environment {
    variables = {
      CLUSTER_NAME                 = var.deployment_name,
      CONFIG_MAP_NAME              = "mattermost-cm-prometheus-server",
      ENVIRONMENT                  = var.environment
      PROMETHEUS_HOSTED_ZONE_ID    = var.prometheus_hosted_zoneid,
      INSTALLATIONS_HOSTED_ZONE_ID = var.installations_hosted_zoneid
    }
  }
}

resource "aws_security_group" "lambda-sg" {
  name        = "${var.deployment_name}-lambda-sg"
  description = "Prometheus DNS Registration Lambda"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.deployment_name}-lambda-sg"
  }
}

resource "aws_cloudwatch_event_rule" "route53_updates" {
  name          = "prometheus-registration"
  description   = "Runs when a new Route53 record is deleted or created"
  event_pattern = <<PATTERN
    {
      "source": [
        "aws.route53"
        ],
      "detail-type": [
        "AWS API Call via CloudTrail"
        ],
      "detail": {
        "eventSource": [
          "route53.amazonaws.com"
          ],
        "eventName": [
          "ChangeResourceRecordSets"
          ]
      }
    }
  PATTERN
}

resource "aws_cloudwatch_event_target" "prometheus-registration" {
  rule      = aws_cloudwatch_event_rule.route53_updates.name
  target_id = "prometheus_registration"
  arn       = aws_lambda_function.prometheus_registration.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_prometheus_registration" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.prometheus_registration.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.route53_updates.arn
}
