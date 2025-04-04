resource "aws_lambda_function" "elb_cleanup" {
  s3_bucket     = var.lambda_s3_bucket
  s3_key        = var.lambda_s3_key
  function_name = "elb-cleanup"
  role          = aws_iam_role.elb_cleanup_lambda_role.arn
  handler       = "bootstrap"
  timeout       = 120
  runtime       = "provided.al2"
  architectures = var.enable_arm64 ? ["arm64"] : ["x86_64"]
  vpc_config {
    subnet_ids         = flatten(var.private_subnet_ids)
    security_group_ids = [aws_security_group.elb_cleanup_lambda_sg.id]
  }

  environment {
    variables = {
      dryrun            = var.dryrun,
      ELB_CLEANUP_DEBUG = var.dryrun
    }
  }
}

resource "aws_security_group" "elb_cleanup_lambda_sg" {
  name        = "${var.deployment_name}-elb-cleanup-lambda-sg"
  description = "ELB Cleanp Lambda"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.deployment_name}-elb-cleanup-lambda-sg"
  }
}

resource "aws_cloudwatch_event_rule" "elb_cleanup" {
  name                = "elb-cleanup"
  description         = "Runs based on the schedule expression"
  schedule_expression = var.elb_cleanup_lambda_schedule
}

resource "aws_cloudwatch_event_target" "elb_cleanup" {
  rule      = aws_cloudwatch_event_rule.elb_cleanup.name
  target_id = "elb-cleanup"
  arn       = aws_lambda_function.elb_cleanup.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_elb_cleanup" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.elb_cleanup.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.elb_cleanup.arn
}
