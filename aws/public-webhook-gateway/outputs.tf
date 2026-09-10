output "invoke_url" {
  description = "Base invoke URL for the stage, e.g. https://abc123.execute-api.us-east-1.amazonaws.com/core"
  value       = aws_api_gateway_stage.public_webhook.invoke_url
}

output "route_urls" {
  description = "Full public URL per route, keyed by route name. Give these to the webhook provider as the payload URL."
  value       = { for k, _ in var.routes : k => "${aws_api_gateway_stage.public_webhook.invoke_url}/${k}" }
}

output "rest_api_id" {
  description = "ID of the REST API, useful for CloudWatch metric dimensions and manual redeploys"
  value       = aws_api_gateway_rest_api.public_webhook.id
}

output "stage_name" {
  description = "Deployed stage name"
  value       = aws_api_gateway_stage.public_webhook.stage_name
}

output "execution_arn" {
  description = "Execution ARN of the REST API, for granting additional invoke permissions outside this module"
  value       = aws_api_gateway_rest_api.public_webhook.execution_arn
}
