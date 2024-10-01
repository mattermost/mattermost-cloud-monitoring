resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  subnet_ids                         = var.subnet_ids
  transit_gateway_id                 = var.transit_gateway_id
  vpc_id                             = var.vpc_id
  security_group_referencing_support = var.security_group_referencing_support
}

resource "aws_route" "private_tgw_attachment_route" {
  for_each               = toset(var.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = var.transit_gtw_route_destination
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "private_tgw_attachment_route_security" {
  for_each               = toset(var.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = var.transit_gtw_route_destination_security
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "private_tgw_attachment_route_gitlab" {
  for_each               = toset(var.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = var.transit_gtw_route_destination_gitlab
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "public_tgw_attachment_route" {
  for_each               = toset(var.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = var.transit_gtw_route_destination
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "public_tgw_attachment_security" {
  for_each               = toset(var.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = var.transit_gtw_route_destination_security
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "public_tgw_attachment_gitlab" {
  for_each               = toset(var.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = var.transit_gtw_route_destination_gitlab
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}
