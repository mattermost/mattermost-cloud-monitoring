resource "aws_cloudwatch_log_group" "es_group" {
  name = "elasticsearch-logs-group"

  tags = {
    Environment = var.environment
    Application = "Elasticsearch"
  }
}

resource "aws_cloudwatch_log_resource_policy" "es_policy" {
  policy_name = "elasticsearch-logs-group"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}
