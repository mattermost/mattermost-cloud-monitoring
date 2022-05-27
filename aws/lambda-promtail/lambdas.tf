resource "aws_lambda_function" "lambda_promtail" {
  s3_bucket     = var.bucket
  s3_key        = "mattermost-cloud/lambda_promtail/main/main.zip"
  function_name = "lambda_promtail"
  role          = aws_iam_role.iam_for_lambda.arn

  timeout     = 60
  memory_size = 128

  # From the Terraform AWS Lambda docs: If both subnet_ids and security_group_ids are empty then vpc_config is considered to be empty or unset.
  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = var.lambda_vpc_subnets
    security_group_ids = var.lambda_vpc_security_groups
  }

  environment {
    variables = {
      WRITE_ADDRESS = var.write_address
      USERNAME      = var.username
      PASSWORD      = var.password
      KEEP_STREAM   = var.keep_stream
      BATCH_SIZE    = var.batch_size
      EXTRA_LABELS  = var.extra_labels
      TENANT_ID     = var.tenant_id
    }
  }

  depends_on = [
    aws_iam_role_policy.logs,
    aws_iam_role_policy_attachment.lambda_vpc_execution,
  ]
}

resource "aws_lambda_function_event_invoke_config" "lambda_promtail_invoke_config" {
  function_name          = aws_lambda_function.lambda_promtail.function_name
  maximum_retry_attempts = 2
}
