# Lambda function for clenaing up old and unused images.
resource "aws_lambda_function" "deckhand" {
  s3_bucket     = var.bucket
  s3_key        = "mattermost-cloud/deckhand/master/main.zip"
  function_name = "deckhand"
  description   = "Lambda"
  role          = aws_iam_role.cleanup_old_images_lambda.arn
  handler       = "main"
  runtime       = "go1.x"
  timeout       = "600"

  # Enable active tracing : X-ray
  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      "REGION"   = var.region
      "OWNER_ID" = var.account_id
    }
  }

  vpc_config {
    subnet_ids         = flatten(var.private_subnet_ids)
    security_group_ids = [aws_security_group.cleanup_old_images_lambda_sg.id]
  }

}
resource "aws_security_group" "cleanup_old_images_lambda_sg" {
  name        = "${var.deployment_name}-cleanup-old-images-lambda-sg"
  description = "Cleanup Old Images Lambda (Deckhand)"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.deployment_name}-cleanup-old-images-lambda-sg"
  }
}
