resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  subnet_ids         = var.subnet_ids
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = var.vpc_id
}

resource "aws_route" "private_tgw_attachment_route" {
  route_table_id         = var.private_route_table_id
  destination_cidr_block = var.transit_gtw_route_destination
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "public_tgw_attachment_route" {
  route_table_id         = var.public_route_table_id
  destination_cidr_block = var.transit_gtw_route_destination
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}
