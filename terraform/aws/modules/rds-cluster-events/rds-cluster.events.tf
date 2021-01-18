// Lambda to receive RDS events via SNS topic
resource "aws_iam_role" "lambda_role_rds_cluster_events" {
  name = "receive_elb_cloudwatch_alarm"

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
  s3_bucket     = "releases.mattermost.com"
  s3_key        = "mattermost-cloud/rds-cluster-events/master/main.zip"
  function_name = "rds-cluster-events"
  role          = aws_iam_role.lambda_role_rds_cluster_events.arn
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
  name = "rds-cluster-events"

  depends_on = [
    aws_lambda_function.rds_cluster_events
  ]
}


// SNS topic that the alarm will be sent
resource "aws_sns_topic_subscription" "lamba_subscriber" {
  topic_arn = aws_sns_topic.rds_cluster_events_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.rds_cluster_events.arn

  depends_on = [
    aws_lambda_function.rds_cluster_events
  ]
}
