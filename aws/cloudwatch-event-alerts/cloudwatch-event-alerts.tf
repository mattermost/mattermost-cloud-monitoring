// Lambda to receive RDS events via SNS topic
resource "aws_iam_role" "lambda_role_cloudwatch_event_alerts" {
  name = "cloudwatch-event-alerts"

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
  role       = aws_iam_role.lambda_role_cloudwatch_event_alerts.name
}


resource "aws_lambda_function" "rds_cluster_events" {
  s3_bucket     = var.lambda_s3_bucket
  s3_key        = var.lambda_s3_key
  function_name = "cloudwatch-event-alerts"
  role          = aws_iam_role.lambda_role_cloudwatch_event_alerts.arn
  handler       = "main"
  timeout       = 120
  runtime       = "go1.x"

  environment {
    variables = {
      MATTERMOST_HOOK         = var.community_webhook
      OPSGENIE_APIKEY         = var.opsgenie_apikey
      OPSGENIE_SCHEDULER_TEAM = var.opsgenie_scheduler_team
      ENVIRONMENT             = var.environment
    }
  }

}

// SNS topic
resource "aws_sns_topic" "rds_cluster_events_topic" {
  name = "cloudwatch-event-alerts"

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

resource "aws_lambda_permission" "rds_cluster_events_topic_perm" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rds_cluster_events.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.rds_cluster_events_topic.arn
}
