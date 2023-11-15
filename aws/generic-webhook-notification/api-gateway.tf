resource "aws_api_gateway_rest_api" "core-generic-webhook-notification" {
  name        = "core-generic-webhook-notification"
  description = "Managed by Terraform"
}

resource "aws_api_gateway_resource" "provisioner-notification-resource" {
  rest_api_id = aws_api_gateway_rest_api.core-generic-webhook-notification.id
  parent_id   = aws_api_gateway_rest_api.core-generic-webhook-notification.root_resource_id
  path_part   = "/api/v1/notification"
}

resource "aws_api_gateway_method" "notification-post" {
  rest_api_id   = aws_api_gateway_rest_api.core-generic-webhook-notification.id
  resource_id   = aws_api_gateway_resource.provisioner-notification-resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "notification-integration" {
  rest_api_id = aws_api_gateway_rest_api.core-generic-webhook-notification.id
  resource_id = aws_api_gateway_resource.provisioner-notification-resource.id
  http_method = aws_api_gateway_method.notification-post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.provisioner-notification.invoke_arn
}

resource "aws_api_gateway_resource" "elrond-notification-resource" {
  rest_api_id = aws_api_gateway_rest_api.core-generic-webhook-notification.id
  parent_id   = aws_api_gateway_rest_api.core-generic-webhook-notification.root_resource_id
  path_part   = "/api/v1/elrond-notification"
}

resource "aws_api_gateway_method" "elrond-notification-post" {
  rest_api_id   = aws_api_gateway_rest_api.core-generic-webhook-notification.id
  resource_id   = aws_api_gateway_resource.elrond-notification-resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "elrond-notification-integration" {
  rest_api_id = aws_api_gateway_rest_api.core-generic-webhook-notification.id
  resource_id = aws_api_gateway_resource.elrond-notification-resource.id
  http_method = aws_api_gateway_method.elrond-notification-post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.elrond-notification.invoke_arn
}

resource "aws_api_gateway_resource" "gitlab-webhook-resource" {
  rest_api_id = aws_api_gateway_rest_api.core-generic-webhook-notification.id
  parent_id   = aws_api_gateway_rest_api.core-generic-webhook-notification.root_resource_id
  path_part   = "/api/v1/gitlab-webhook"
}

resource "aws_api_gateway_method" "gitlab-webhook-post" {
  rest_api_id   = aws_api_gateway_rest_api.core-generic-webhook-notification.id
  resource_id   = aws_api_gateway_resource.gitlab-webhook-resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "gitlab-webhook-integration" {
  rest_api_id = aws_api_gateway_rest_api.core-generic-webhook-notification.id
  resource_id = aws_api_gateway_resource.gitlab-webhook-resource.id
  http_method = aws_api_gateway_method.gitlab-webhook-post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.gitlab-webhook.invoke_arn
}
