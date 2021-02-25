resource "aws_cloudwatch_event_rule" "deckhandcron" {
  name        = "deckhandcron"
  description = "Schedules deckhand cron to run."

  depends_on = [aws_lambda_function.deckhand]

  schedule_expression = "cron(0 10 ? * MON *)" #runs every monday at 10am UTC
}

resource "aws_cloudwatch_metric_alarm" "lambda_deckhand_errors" {
  alarm_name          = "Lambda deckhand - Errors"
  alarm_description   = "This lambda cleans up unused images 30days old or more and their snapshots. This alarm indicates the lambda had Errors when it was executed."
  evaluation_periods  = "1"
  period              = "10800"
  threshold           = "1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_actions       = [aws_sns_topic.cleanup_images_sns_topic.arn]
  namespace           = "AWS/Lambda"
  treat_missing_data  = "missing"
  statistic           = "Sum"
  metric_name         = "Errors"

  dimensions = {
    FunctionName = "deckhand"
    Resource     = "deckhand"
  }

  depends_on = [
    aws_sns_topic.cleanup_images_sns_topic
  ]
}

resource "aws_sns_topic" "cleanup_images_sns_topic" {
  name = "cleanup_images_sns_topic"

  depends_on = [
    aws_lambda_function.deckhand
  ]
}
