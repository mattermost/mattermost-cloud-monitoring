resource "aws_iam_role" "bind_lambda_role" {
  name = "iam_for_lambda_bind"

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

resource "aws_iam_role_policy" "EC2Access" {
  name = "bind_lambda_policy"
  role = aws_iam_role.bind_lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Action": [
            "ec2:CreateNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DetachNetworkInterface",
            "ec2:DeleteNetworkInterface",
            "ec2:AttachNetworkInterface",
            "ec2:DescribeInstances",
            "autoscaling:CompleteLifecycleAction"
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
  role       = aws_iam_role.bind_lambda_role.name
}

resource "aws_lambda_function" "bind_server_network_attachment" {
  s3_bucket     = var.lambda_s3_bucket
  s3_key        = var.lambda_s3_key
  function_name = "bind-server-network-attachment"
  role          = aws_iam_role.bind_lambda_role.arn
  handler       = "main"
  timeout       = 120
  runtime       = "go1.x"
  vpc_config {
    subnet_ids         = flatten([var.subnet_ids])
    security_group_ids = [aws_security_group.bind_lambda_sg.id]
  }
}

resource "aws_security_group" "bind_lambda_sg" {
  name        = "mattermost-bind-lambda-sg"
  description = "Bind Server Network Attachment Lambda"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mattermost-bind-lambda-sg"
  }
}

resource "aws_cloudwatch_event_rule" "autoscaling_bind_updates" {
  name          = "bind-server-autoscaling"
  description   = "Runs when a new EC2 is launched in the autoscaling group"
  event_pattern = <<PATTERN
    {
      "source": [
        "aws.autoscaling"
      ],
      "detail-type": [
        "EC2 Instance-launch Lifecycle Action"
      ],
      "detail": {
        "AutoScalingGroupName": [
          "autoscale-bind-server"
        ]
      }
    }
  PATTERN
}

resource "aws_cloudwatch_event_target" "bind_server_autoscaling" {
  rule      = aws_cloudwatch_event_rule.autoscaling_bind_updates.name
  target_id = "bind-server-autoscaling"
  arn       = aws_lambda_function.bind_server_network_attachment.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_bind" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.bind_server_network_attachment.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.autoscaling_bind_updates.arn
}
