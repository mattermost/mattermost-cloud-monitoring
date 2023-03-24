output "this_route_table_ids" {
  description = "The ID of the routing tables"
  value       = var.route_table_ids
}

output "this_transit_gateway_id" {
  description = "The ID of an EC2 Transit Gateway"
  value       = var.transit_gateway_id
}

output "this_destination_cidr_block" {
  description = "The destination CIDR block"
  value       = var.destination_cidr_block
}
