resource "aws_iam_role" "database_factory_horizontal_scaling_lambda_role" {
  name = "database_factory_horizontal_scaling_lambda_role"

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

resource "aws_iam_role_policy" "database_factory_horizontal_scaling_lambda_policy" {
  name = "database_factory_horizontal_scaling_lambda_policy"
  role = aws_iam_role.database_factory_horizontal_scaling_lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
            "cloudwatch:PutMetricData",
            "ec2:DescribeVpcs",
            "tag:GetResources"
        ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRoleDBFactoryHS" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.database_factory_horizontal_scaling_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRoleDBFactoryHS" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.database_factory_horizontal_scaling_lambda_role.name
}

resource "aws_lambda_function" "database_factory_horizontal_scaling" {
  s3_bucket     = var.lambda_s3_bucket
  s3_key        = var.lambda_s3_key
  function_name = "database-factory-horizontal-scaling"
  role          = aws_iam_role.database_factory_horizontal_scaling_lambda_role.arn
  handler       = "main"
  timeout       = 300
  runtime       = "go1.x"
  vpc_config {
    subnet_ids         = flatten(var.private_subnet_ids)
    security_group_ids = [aws_security_group.database_factory_horizontal_scaling_lambda_sg.id]
  }

  environment {
    variables = {
      RDSMultitenantDBClusterNamePrefix      = var.rds_multitenant_dbcluster_name_prefix,
      RDSMultitenantDBClusterTagPurpose      = var.rds_multitenant_dbcluster_tag_purpose,
      RDSMultitenantDBClusterTagDatabaseType = var.rds_multitenant_dbcluster_tag_database_type,
      MaxAllowedInstallations                = var.max_allowed_installations,
      Environment                            = var.environment,
      StateStore                             = var.state_store,
      DBInstanceType                         = var.db_instance_type,
      TerraformApply                         = var.terraform_apply,
      BackupRetentionPeriod                  = var.backup_retention_period,
      DatabaseFactoryEndpoint                = var.database_factory_endpoint
      MattermostNotificationsHook            = var.mattermost_notifications_hook
      MattermostAlertsHook                   = var.mattermost_alerts_hook
    }
  }
}

resource "aws_security_group" "database_factory_horizontal_scaling_lambda_sg" {
  name        = "database-factory-horizontal-scaling-lambda-sg"
  description = "Database factory horizontal scaling lambda"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database-factory-horizontal-scaling-lambda-sg"
  }
}

resource "aws_cloudwatch_event_rule" "database_factory_horizontal_scaling_cron" {
  name                = "CheckDBClusterInstallations"
  description         = "Runs based on the schedule expression"
  schedule_expression = var.database_factory_horizontal_scaling_lambda_schedule
}

resource "aws_cloudwatch_event_target" "database_factory_horizontal_scaling" {
  rule      = aws_cloudwatch_event_rule.database_factory_horizontal_scaling_cron.name
  target_id = "database-factory-horizontal-scaling"
  arn       = aws_lambda_function.database_factory_horizontal_scaling.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_database_factory_horizontal_scaling" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.database_factory_horizontal_scaling.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.database_factory_horizontal_scaling_cron.arn
}
