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
  tags                            = var.tags
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

resource "aws_ec2_transit_gateway_vpc_attachment" "external" {
  subnet_ids                         = var.tgw_attachment_subnet_ids
  transit_gateway_id                 = aws_ec2_transit_gateway.mattermost-cloud-tgw.id
  vpc_id                             = var.tgw_attachment_vpc_id
  security_group_referencing_support = var.security_group_referencing_support
}

resource "aws_ec2_transit_gateway_peering_attachment" "use1_usw2" {
  peer_account_id         = var.peer_account_id
  peer_region             = var.peer_region
  peer_transit_gateway_id = var.peer_transit_gateway_id
  transit_gateway_id      = aws_ec2_transit_gateway.mattermost-cloud-tgw.id

  tags = {
    Name = var.tgw_peering_attachment_name
  }
}

resource "aws_ec2_transit_gateway_route" "cloud" {
  destination_cidr_block         = var.cloud_destination_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.use1_usw2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.mattermost-cloud-tgw.association_default_route_table_id
}

resource "aws_ec2_transit_gateway_route" "security" {
  destination_cidr_block         = var.security_destination_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.use1_usw2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.mattermost-cloud-tgw.association_default_route_table_id
}
