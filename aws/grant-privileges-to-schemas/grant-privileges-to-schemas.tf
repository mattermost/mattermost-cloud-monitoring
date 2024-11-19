resource "aws_iam_role" "grant-privileges-to-schemas_lambda_role" {
  name = "grant-privileges-to-schemas_lambda_role"

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

resource "aws_iam_role_policy" "grant-privileges-to-schemas_lambda_policy" {
  name = "grant-privileges-to-schemas_lambda_policy"
  role = aws_iam_role.grant-privileges-to-schemas_lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
          "secretsmanager:GetSecretValue",
          "rds:DescribeDBClusters",
          "rds:ListTagsForResource"
        ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRoleGrantPrivilegesToSchemas" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.grant-privileges-to-schemas_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRoleGrantPrivilegesToSchemas" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.grant-privileges-to-schemas_lambda_role.name
}

resource "aws_lambda_function" "grant-privileges-to-schemas" {
  s3_bucket     = var.lambda_s3_bucket
  s3_key        = var.lambda_s3_key
  function_name = "grant-privileges-to-schemas"
  role          = aws_iam_role.grant-privileges-to-schemas_lambda_role.arn
  handler       = "bootstrap"
  timeout       = 900
  runtime       = "provided.al2"
  vpc_config {
    subnet_ids         = flatten(var.private_subnet_ids)
    security_group_ids = [aws_security_group.grant-privileges-to-schemas_lambda_sg.id]
  }

  environment {
    variables = {
      DB_USERNAME         = var.db_username,
      ENVIRONMENT         = var.environment,
      PROVISIONER_DB_URL  = var.provisioner_db_url,
      PROVISIONER_DB_USER = var.provisioner_db_user,
      EXCLUDED_CLUSTERS   = var.excluded_clusters,
      ACTIVITY_DATE       = var.activity_date
    }
  }
}

resource "aws_security_group" "grant-privileges-to-schemas_lambda_sg" {
  name        = "${var.deployment_name}-grant-privileges-to-schemas-lambda-sg"
  description = "Grant Privileges To Schemas Lambda"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.deployment_name}-grant-privileges-to-schemas-lambda-sg"
  }
}

resource "aws_cloudwatch_event_rule" "grant-privileges-to-schemas" {
  name                = "grant-privileges-to-schemas"
  description         = "Runs based on the schedule expression"
  schedule_expression = var.grant-privileges-to-schemas_lambda_schedule
}

resource "aws_cloudwatch_event_target" "grant-privileges-to-schemas" {
  rule      = aws_cloudwatch_event_rule.grant-privileges-to-schemas.name
  target_id = "grant-privileges-to-schemas"
  arn       = aws_lambda_function.grant-privileges-to-schemas.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_grant-privileges-to-schemas" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.grant-privileges-to-schemas.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.grant-privileges-to-schemas.arn
}
