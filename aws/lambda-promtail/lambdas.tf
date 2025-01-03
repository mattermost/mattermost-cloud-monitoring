resource "aws_lambda_function" "lambda_promtail" {
  s3_bucket     = var.lambda_s3_bucket
  s3_key        = var.lambda_s3_key
  function_name = var.function_name
  role          = aws_iam_role.promtail_lambda.arn
  handler       = "bootstrap"
  runtime       = "provided.al2"
  timeout       = 60
  architectures = var.enable_arm64 ? ["arm64"] : ["x86_64"]
  memory_size   = 128

  # From the Terraform AWS Lambda docs: If both subnet_ids and security_group_ids are empty then vpc_config is considered to be empty or unset.
  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = flatten(var.private_subnet_ids)
    security_group_ids = [aws_security_group.lambda_promtail_sg.id]
  }

  environment {
    variables = {
      WRITE_ADDRESS   = var.write_address
      USERNAME        = var.username
      PASSWORD        = var.password
      KEEP_STREAM     = var.keep_stream
      BATCH_SIZE      = var.batch_size
      EXTRA_LABELS    = var.extra_labels
      TENANT_ID       = var.tenant_id
      INCLUDE_MESSAGE = var.include_message
    }
  }

}

resource "aws_lambda_function_event_invoke_config" "lambda_promtail_invoke_config" {
  function_name          = aws_lambda_function.lambda_promtail.function_name
  maximum_retry_attempts = 2
}

resource "aws_security_group" "lambda_promtail_sg" {
  name        = "${var.deployment_name}-lambda-promtail-sg"
  description = "Promtail Lambda"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.deployment_name}-lambda-promtail-sg"
  }
}
