resource "aws_cloudwatch_log_group" "lambda_promtail" {
  name              = "/aws/lambda/lambda_promtail"
  retention_in_days = 14
}

resource "aws_lambda_permission" "lambda_promtail_allow_cloudwatch" {
  statement_id  = "lambda-promtail-allow-cloudwatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_promtail.function_name
  principal     = "logs.${data.aws_region.current.name}.amazonaws.com"
}

# This block allows for easily subscribing to multiple log groups via the `log_group_names` var.
# However, if you need to provide an actual filter_pattern for a specific log group you should
# copy this block and modify it accordingly.
resource "aws_cloudwatch_log_subscription_filter" "lambdafunction_logfilter" {
  for_each        = toset(var.log_group_names)
  name            = "lambdafunction_logfilter_${each.value}"
  log_group_name  = each.value
  destination_arn = aws_lambda_function.lambda_promtail.arn
  # required but can be empty string
  filter_pattern = ""
  depends_on     = [aws_iam_role_policy.logs]
}

resource "aws_lambda_permission" "allow-s3-invoke-lambda-promtail" {
  for_each      = toset(var.bucket_names)
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_promtail.arn
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${each.value}"
}

resource "aws_s3_bucket_notification" "push-to-lambda-promtail" {
  for_each = toset(var.bucket_names)
  bucket   = each.value

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_promtail.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "AWSLogs/"
    filter_suffix       = ".log.gz"
  }

  depends_on = [aws_lambda_permission.allow-s3-invoke-lambda-promtail]
}
