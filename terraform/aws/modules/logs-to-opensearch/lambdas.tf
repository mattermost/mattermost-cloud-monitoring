# Lambda function for shipping cloudwatch logs to Opensearch
resource "aws_lambda_function" "logs_to_opensearch" {
  s3_bucket     = var.bucket
  s3_key        = "mattermost-cloud/logs-to-opensearch/master/logs-to-opensearch.zip"
  function_name = "deckhand"
  description   = "Lambda"
  role          = aws_iam_role.logs_to_opensearch.arn
  handler       = "logs-to-opensearch"
  runtime       = "nodejs14.x"
  timeout       = "600"


  environment {
    variables = {
      "es_endpoint"   = var.es_endpoint
    }
  }

  vpc_config {
    subnet_ids         = flatten(var.private_subnet_ids)
    security_group_ids = [aws_security_group.logs_to_opensearch_sg.id]
  }

}
resource "aws_security_group" "logs_to_opensearch_sg" {
  name        = "${var.deployment_name}-logs-to-opensearch-sg"
  description = "Ship Cloudwatch Logs to Opensearch"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.deployment_name}-logs-to-opensearch-sg"
  }
}
