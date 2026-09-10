# Access log destination. Created only when access logging is enabled, so the
# module does not leave an empty log group behind in the common case.
#
# The /aws/vendedlogs/ prefix is deliberate: API Gateway will not accept a
# destination_arn for a REST API stage unless the log group name begins with
# API-Gateway-Execution-Logs_ or /aws/vendedlogs/.
resource "aws_cloudwatch_log_group" "access_logs" {
  count = var.enable_access_logging ? 1 : 0

  name              = "/aws/vendedlogs/apigateway/${var.deployment_name}-public-webhook/${var.environment}"
  retention_in_days = var.log_retention_in_days
  tags              = var.tags
}
