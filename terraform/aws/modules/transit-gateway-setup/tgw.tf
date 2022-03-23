###########################
# Resource Transit Gateway
###########################
resource "aws_ec2_transit_gateway" "mattermost-cloud-tgw" {
  description                     = var.description
  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = var.enable_auto_accept_shared_attachments
  default_route_table_association = var.enable_default_route_table_association
  default_route_table_propagation = var.enable_default_route_table_propagation
  dns_support                     = var.enable_dns_support
  tags                            = var.tag
}

##########################
# Resource Access Manager
##########################
resource "aws_ram_resource_share" "tgw-share" {

  name                      = var.ram_name
  allow_external_principals = var.ram_allow_external_principals

  tags = merge(
    {
      "Name" = format("%s", coalesce(var.ram_name, var.name))
    },
    var.tags,
    var.ram_tags,
  )
}

resource "aws_ram_resource_association" "ram-tgw-association" {
  resource_arn       = aws_ec2_transit_gateway.mattermost-cloud-tgw.arn
  resource_share_arn = aws_ram_resource_share.tgw-share.id
}

resource "aws_ram_principal_association" "ram-principal" {
  principal          = var.ram_principals[0]
  resource_share_arn = aws_ram_resource_share.tgw-share.arn
}
