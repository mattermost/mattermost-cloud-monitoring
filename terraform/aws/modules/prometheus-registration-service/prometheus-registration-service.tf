resource "aws_iam_role_policy" "EKSAccess" {
  name = "test_policy"
  role = var.lambda_role_id

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
  role       = var.lambda_role_name
}

resource "aws_iam_role_policy_attachment" "AmazonRoute53ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53ReadOnlyAccess"
  role       = var.lambda_role_name
}


resource "aws_lambda_function" "prometheus_registration" {
  s3_bucket     = "releases.mattermost.com"
  s3_key        = "mattermost-cloud/prometheus-dns-registration-service/master/main.zip"
  function_name = "prometheus-dns-registration-service"
  role          = var.lambda_role_arn
  handler       = "main"
  timeout       = 120
  runtime       = "go1.x"
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

resource "aws_security_group_rule" "prometheus-lambda-ingress" {
  description              = "Allow prometheus lambda registration service to communicate with cluster"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = var.cluster-sg
  source_security_group_id = aws_security_group.lambda-sg.id
  to_port                  = 443
  type                     = "ingress"
}
