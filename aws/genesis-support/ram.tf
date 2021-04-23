data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_ram_resource_share" "tgw_share_test" {
  name                      = var.share_name_test
  allow_external_principals = false
}

resource "aws_ram_resource_share" "tgw_share_prod" {
  name                      = var.share_name_prod
  allow_external_principals = false
}

resource "aws_ram_resource_association" "tgw_share_resource_association_test" {
  resource_arn       = "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:transit-gateway/${var.cloud_enterprise_test_tgw}"
  resource_share_arn = aws_ram_resource_share.tgw_share_test.arn
}

resource "aws_ram_resource_association" "tgw_share_resource_association_prod" {
  resource_arn       = "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:transit-gateway/${var.cloud_enterprise_prod_tgw}"
  resource_share_arn = aws_ram_resource_share.tgw_share_prod.arn
}

