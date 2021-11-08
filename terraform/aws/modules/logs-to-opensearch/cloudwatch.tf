
resource "aws_cloudwatch_metric_alarm" "logs_to_opensearch_errors" {
  alarm_name          = "Lambda logs-to-opensearch - Errors"
  alarm_description   = "This lambda ships logs to AWS Opensearch Service. This alarm indicates the lambda had Errors when it was executed."
  evaluation_periods  = var.alarm_evaluation_periods
  period              = var.alarm_period
  threshold           = var.alarm_threshold
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_actions       = [aws_sns_topic.logs_to_opensearch_sns_topic.arn]
  namespace           = "AWS/Lambda"
  treat_missing_data  = "missing"
  statistic           = "Sum"
  metric_name         = "Errors"

  dimensions = {
    FunctionName = "logs-to-opensearch"
    Resource     = "logs-to-opensearch"
  }

  depends_on = [
    aws_sns_topic.logs_to_opensearch_sns_topic
  ]
}

resource "aws_sns_topic" "logs_to_opensearch_sns_topic" {
  name = "logs-to-opensearch-sns-topic"

  depends_on = [
    aws_lambda_function.logs_to_opensearch
  ]
}
