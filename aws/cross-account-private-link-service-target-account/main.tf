// Create VPC Endpoint in the target account
resource "aws_vpc_endpoint" "endpoint" {
  provider            = aws.target
  vpc_id              = var.vpc_id
  service_name        = var.service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.subnet_id]
  security_group_ids  = [var.security_group_id]
  private_dns_enabled = false

  depends_on = [aws_iam_role_policy_attachment.target_role_attachment]
}

