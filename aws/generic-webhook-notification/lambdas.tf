resource "aws_lambda_function" "provisioner-notification" {
  function_name = "provisioner-notification"
  runtime       = "provided.al2"
  role          = aws_iam_role.generic-webhook.arn
  memory_size   = 128
  timeout       = 120
  handler       = "bootstrap"

  s3_bucket = var.lambda_s3_bucket
  s3_key    = var.lambda_provisioner_notification_s3_key

  vpc_config {
    subnet_ids         = flatten(var.private_subnet_ids)
    security_group_ids = [aws_security_group.generic-lambda_sg.id]
  }

  environment {
    variables = {
      MATTERMOST_WEBHOOK_PROD       = var.mattermost_webhook_prod
      MATTERMOST_WEBHOOK_ALERT_PROD = var.mattermost_webhook_alert_prod
      OPSGENIE_APIKEY               = var.opsgenie_apikey
      OPSGENIE_SCHEDULER_TEAM       = var.opsgenie_scheduler_team
    }
  }
}

resource "aws_lambda_function" "elrond-notification" {
  function_name = "elrond-notification"
  runtime       = "provided.al2"
  role          = aws_iam_role.generic-webhook.arn
  memory_size   = 128
  timeout       = 120
  handler       = "bootstrap"

  s3_bucket = var.lambda_s3_bucket
  s3_key    = var.lambda_elrond_notification_s3_key

  vpc_config {
    subnet_ids         = flatten(var.private_subnet_ids)
    security_group_ids = [aws_security_group.generic-lambda_sg.id]
  }

  environment {
    variables = {
      MATTERMOST_ELROND_WEBHOOK_PROD = var.mattermost_elrond_webhook_prod
      MATTERMOST_WEBHOOK_ALERT_PROD  = var.mattermost_webhook_alert_prod
      OPSGENIE_APIKEY                = var.opsgenie_apikey
      OPSGENIE_SCHEDULER_TEAM        = var.opsgenie_scheduler_team
      ENVIRONMENT                    = "PROD"
    }
  }
}

resource "aws_lambda_function" "gitlab-webhook" {
  function_name = "gitlab-webhook"
  runtime       = "provided.al2"
  role          = aws_iam_role.generic-webhook.arn
  memory_size   = 128
  timeout       = 120
  handler       = "bootstrap"

  s3_bucket = var.lambda_s3_bucket
  s3_key    = var.lambda_gitlab_webhook_s3_key

  vpc_config {
    subnet_ids         = flatten(var.private_subnet_ids)
    security_group_ids = [aws_security_group.generic-lambda_sg.id]
  }

  environment {
    variables = {
      MATTERMOST_NOTIFICATION_HOOK = var.mattermost_notification_hook
    }
  }
}

resource "aws_lambda_permission" "provisioner-notification-permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.provisioner-notification.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.core-generic-webhook-notification.execution_arn}/*/${aws_api_gateway_method.notification-post.http_method}/${aws_api_gateway_resource.provisioner-notification-resource.path_part}"
}


resource "aws_lambda_permission" "elrond-notification-permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.elrond-notification.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.core-generic-webhook-notification.execution_arn}/*/${aws_api_gateway_method.elrond-notification-post.http_method}/${aws_api_gateway_resource.elrond-notification-resource.path_part}"
}

resource "aws_lambda_permission" "gitlab-webhook-permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.gitlab-webhook.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.core-generic-webhook-notification.execution_arn}/*/${aws_api_gateway_method.gitlab-webhook-post.http_method}/${aws_api_gateway_resource.gitlab-webhook-resource.path_part}"
}

resource "aws_security_group" "generic-lambda_sg" {
  name        = "${var.deployment_name}-generic-webhook-lambda-sg"
  description = "generic webhook lambdas"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.deployment_name}-generic-webhook-lambda-sg"
  }
}





