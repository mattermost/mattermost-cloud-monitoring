resource "aws_cloudwatch_log_group" "lambda_promtail" {
  name              = var.cloudwatch_log_group
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
  name            = "lambdafunction_logfilter_${aws_lambda_function.lambda_promtail.function_name}${each.value}"
  log_group_name  = each.value
  destination_arn = aws_lambda_function.lambda_promtail.arn
  # required but can be empty string
  filter_pattern = var.filter_pattern
  depends_on     = [aws_iam_role_policy.logs]
}
