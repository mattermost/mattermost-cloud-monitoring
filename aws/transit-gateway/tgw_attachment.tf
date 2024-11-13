locals {
  flattened_private_routes = flatten([
    for route_table in var.private_route_table_ids : [
      for route in var.private_tgw_routes : {
        route_table    = route_table
        route_cidr     = route
      }
    ]
  ])
  flattened_public_routes = flatten([
    for route_table in var.public_route_table_ids : [
      for route in var.public_tgw_routes : {
        route_table    = route_table
        route_cidr     = route
      }
    ]
  ])
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  subnet_ids                         = var.subnet_ids
  transit_gateway_id                 = var.transit_gateway_id
  vpc_id                             = var.vpc_id
  security_group_referencing_support = var.security_group_referencing_support
}

resource "aws_route" "private_tgw_attachment_route" {
  for_each               = {for idx, route in local.flattened_private_routes : "${route.route_table}-${idx}" => route}
  route_table_id         = each.value.route_table
  destination_cidr_block = each.value.route_cidr
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}


resource "aws_route" "public_tgw_attachment_route" {
  for_each               = {for idx, route in local.flattened_public_routes : "${route.route_table}-${idx}" => route}
  route_table_id         = each.value.route_table
  destination_cidr_block = each.value.route_cidr
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}
