# Public ingress for webhooks sent by providers outside the VPC, such as GitHub.com.
#
# This exists because core-generic-webhook-notification is a PRIVATE REST API,
# reachable only from inside the VPC through an interface VPC endpoint. Every route
# on that API is called by an internal service, so it was never a problem until a
# route needed to receive deliveries from the public internet. Rather than convert
# that API to REGIONAL - which would change the ingress posture of three working
# internal integrations - external webhooks get their own regional gateway here.

resource "aws_api_gateway_rest_api" "public_webhook" {
  name        = "${var.deployment_name}-public-webhook"
  description = "Public ingress for external webhook providers. Managed by Terraform."

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = var.tags
}

resource "aws_api_gateway_resource" "route" {
  for_each = var.routes

  rest_api_id = aws_api_gateway_rest_api.public_webhook.id
  parent_id   = aws_api_gateway_rest_api.public_webhook.root_resource_id
  path_part   = each.key
}

# Webhook providers POST. Authorization is NONE because each downstream Lambda
# authenticates the request itself - GitHub, for example, is verified via the
# X-Hub-Signature-256 HMAC over the raw body. The gateway's job here is edge
# throttling and observability, not authentication.
resource "aws_api_gateway_method" "route" {
  for_each = var.routes

  rest_api_id   = aws_api_gateway_rest_api.public_webhook.id
  resource_id   = aws_api_gateway_resource.route[each.key].id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "route" {
  for_each = var.routes

  rest_api_id = aws_api_gateway_rest_api.public_webhook.id
  resource_id = aws_api_gateway_resource.route[each.key].id
  http_method = aws_api_gateway_method.route[each.key].http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = each.value.lambda_invoke_arn
}

resource "aws_lambda_permission" "route" {
  for_each = var.routes

  statement_id  = "AllowInvokeFrom-${var.deployment_name}-public-webhook-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.public_webhook.execution_arn}/*/${aws_api_gateway_method.route[each.key].http_method}/${each.key}"

  lifecycle {
    # AWS caps StatementId at 100 characters. The composed value is
    # "AllowInvokeFrom-" + deployment_name + "-public-webhook-" + route key, so a
    # long deployment_name or route key can overflow it and fail at apply. This
    # cannot be a variable validation block: those may only reference their own
    # variable until Terraform 1.9, and this module supports >= 1.6.3.
    precondition {
      condition     = length("AllowInvokeFrom-${var.deployment_name}-public-webhook-${each.key}") <= 100
      error_message = "Composed Lambda statement_id exceeds AWS's 100-character limit. Shorten deployment_name or the route key."
    }
  }
}

# The triggers hash is what makes routes actually go live.
#
# Without it, API Gateway keeps serving whichever deployment the stage was first
# pointed at, and every route added later exists in the API definition but is never
# served. That is not hypothetical: core-generic-webhook-notification served a single
# deployment from 2022-11-21 for four years, so a route added in 2026 had to be
# published by hand. Any resource, method or integration added to this module must be
# added to this hash too.
resource "aws_api_gateway_deployment" "public_webhook" {
  rest_api_id = aws_api_gateway_rest_api.public_webhook.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.public_webhook,
      aws_api_gateway_resource.route,
      aws_api_gateway_method.route,
      aws_api_gateway_integration.route,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "public_webhook" {
  rest_api_id   = aws_api_gateway_rest_api.public_webhook.id
  deployment_id = aws_api_gateway_deployment.public_webhook.id
  stage_name    = var.environment
  tags          = var.tags

  dynamic "access_log_settings" {
    for_each = var.enable_access_logging ? [1] : []

    content {
      destination_arn = aws_cloudwatch_log_group.access_logs[0].arn
      format = jsonencode({
        requestId      = "$context.requestId"
        ip             = "$context.identity.sourceIp"
        requestTime    = "$context.requestTime"
        httpMethod     = "$context.httpMethod"
        resourcePath   = "$context.resourcePath"
        status         = "$context.status"
        responseLength = "$context.responseLength"
        userAgent      = "$context.identity.userAgent"
        integrationErr = "$context.integrationErrorMessage"
      })
    }
  }
}

# Edge throttling and CloudWatch metrics. Metrics need no account-level role, so
# request count, 4xx, 5xx and latency are available even with access logging off.
# Throttling here rejects floods before any Lambda is invoked, which is the main
# reason to put a gateway in front of a self-authenticating webhook receiver.
resource "aws_api_gateway_method_settings" "route" {
  rest_api_id = aws_api_gateway_rest_api.public_webhook.id
  stage_name  = aws_api_gateway_stage.public_webhook.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled        = true
    throttling_rate_limit  = var.throttling_rate_limit
    throttling_burst_limit = var.throttling_burst_limit
  }
}
