resource "aws_vpc_endpoint" "target_account_vpce" {
  vpc_id             = var.vpc_id
  service_name       = var.service_name
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
}
