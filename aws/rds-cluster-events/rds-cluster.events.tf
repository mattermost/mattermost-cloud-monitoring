// Lambda to receive RDS events via SNS topic
resource "aws_iam_role" "lambda_role_rds_cluster_events" {
  name = "rds-cluster-events"

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

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole_alert" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role_rds_cluster_events.name
}


resource "aws_lambda_function" "rds_cluster_events" {
  s3_bucket     = var.lambda_s3_bucket
  s3_key        = var.lambda_s3_key
  function_name = "rds-cluster-events"
  role          = aws_iam_role.lambda_role_rds_cluster_events.arn
  handler       = "bootstrap"
  timeout       = 120
  runtime       = "provided.al2"
  architectures = var.enable_arm64 ? ["arm64"] : ["x86_64"]

  environment {
    variables = {
      MATTERMOST_HOOK           = var.community_webhook
      PAGERDUTY_APIKEY          = var.pagerduty_apikey
      EMAIL_ADDRESS             = var.pagerduty_email_address
      PAGERDUTY_INTEGRATION_KEY = var.pagerduty_integration_key
      ENVIRONMENT               = var.environment
    }
  }

}

// SNS topic
resource "aws_sns_topic" "rds_cluster_events_topic" {
  name = "rds-cluster-events"

  depends_on = [
    aws_lambda_function.rds_cluster_events
  ]
}


// SNS topic that the alarm will be sent
resource "aws_sns_topic_subscription" "rds_cluster_events_sub" {
  topic_arn = aws_sns_topic.rds_cluster_events_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.rds_cluster_events.arn

  depends_on = [
    aws_lambda_function.rds_cluster_events
  ]
}


resource "aws_db_event_subscription" "rds_cluster_events_topic" {
  name      = "rds-cluster-events"
  sns_topic = aws_sns_topic.rds_cluster_events_topic.arn

  source_type = "db-cluster"

  event_categories = [
    "failover",
    "failure",
  ]
}

resource "aws_lambda_permission" "rds_cluster_events_topic_perm" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rds_cluster_events.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.rds_cluster_events_topic.arn
}
