resource "aws_route" "this" {
  for_each = toset(var.route_table_ids)

  route_table_id         = each.value
  transit_gateway_id     = var.transit_gateway_id
  destination_cidr_block = var.destination_cidr_block
  timeouts {
    create = var.timeout_create
  }
}
