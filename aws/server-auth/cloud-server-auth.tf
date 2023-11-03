data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_role" "auth_lambda_role" {
  name = "iam_for_lambda_auth"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSAuthLambdaBasicExecutionRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.auth_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.auth_lambda_role.name
}

resource "aws_lambda_function" "cloud_server_auth" {
  s3_bucket     = var.lambda_s3_bucket
  s3_key        = var.lambda_s3_key
  function_name = "cloud-server-auth"
  role          = aws_iam_role.auth_lambda_role.arn
  handler       = "bootstrap"
  timeout       = 180
  runtime       = "provided.al2"
  vpc_config {
    subnet_ids         = flatten(var.auth_private_subnet_ids)
    security_group_ids = [aws_security_group.auth_lambda_sg.id]
  }

  environment {
    variables = {
      CLOUD_SERVER       = var.provisioner_server,
      MATTERMOST_WEBHOOK = var.community_webhook,
    }
  }
}

resource "aws_security_group" "auth_lambda_sg" {
  name        = "${var.deployment_name}-auth-lambda-sg"
  description = "Cloud Server Auth Lambda"
  vpc_id      = var.auth_vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.deployment_name}-auth-lambda-sg"
  }
}


resource "aws_api_gateway_rest_api" "cloud_server_auth" {
  name        = "cloud-server-auth"
  description = "The rest API for Cloud Server Auth"
  endpoint_configuration {
    types = ["PRIVATE"]
  }
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Principal": "*",
            "Action": "execute-api:Invoke",
            "Resource": "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*",
            "Condition": {
                "StringNotEquals": {
                    "aws:sourceVpce": ${jsonencode(var.api_gateway_vpc_endpoints)}
                }
            }
        },
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "execute-api:Invoke",
            "Resource": "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
        }
    ]
}
EOF
}

resource "aws_api_gateway_resource" "cloud_server_auth_resource" {
  rest_api_id = aws_api_gateway_rest_api.cloud_server_auth.id
  parent_id   = aws_api_gateway_rest_api.cloud_server_auth.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "cloud_server_auth_method" {
  rest_api_id      = aws_api_gateway_rest_api.cloud_server_auth.id
  resource_id      = aws_api_gateway_resource.cloud_server_auth_resource.id
  http_method      = "ANY"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_deployment" "cloud_server_auth_deployment" {
  rest_api_id = aws_api_gateway_rest_api.cloud_server_auth.id
  stage_name  = var.environment
  depends_on = [
    aws_api_gateway_method.cloud_server_auth_method,
    aws_api_gateway_integration.cloud_server_auth_integration
  ]
}

resource "aws_api_gateway_usage_plan" "cloud_server_auth_usageplan" {
  name        = "cloud-server-auth-usage-plan"
  description = "Usage plan for Cloud Server Auth"

  api_stages {
    api_id = aws_api_gateway_rest_api.cloud_server_auth.id
    stage  = aws_api_gateway_deployment.cloud_server_auth_deployment.stage_name
  }
}

resource "aws_api_gateway_api_key" "cloud_server_auth_api_key" {
  name = "cloud-server-auth"
}

resource "aws_api_gateway_usage_plan_key" "cloud_server_auth_api_key" {
  key_id        = aws_api_gateway_api_key.cloud_server_auth_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.cloud_server_auth_usageplan.id
}

resource "aws_api_gateway_integration" "cloud_server_auth_integration" {
  rest_api_id             = aws_api_gateway_rest_api.cloud_server_auth.id
  resource_id             = aws_api_gateway_resource.cloud_server_auth_resource.id
  http_method             = aws_api_gateway_method.cloud_server_auth_method.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.cloud_server_auth.invoke_arn
  integration_http_method = "POST"
}

resource "aws_lambda_permission" "cloud_server_auth_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloud_server_auth.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.cloud_server_auth.id}/*/${aws_api_gateway_method.cloud_server_auth_method.http_method}${aws_api_gateway_resource.cloud_server_auth_resource.path}"
}
