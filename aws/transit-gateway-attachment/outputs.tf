output "this_subnet_ids" {
  description = "The IDs of the subnets"
  value       = var.subnet_ids
}
output "this_transit_gateway_id" {
  description = "The ID of an EC2 Transit Gateway"
  value       = var.transit_gateway_id
}
output "this_vpc_id" {
  description = "The ID of the VPC"
  value       = var.vpc_id
}
output "this_name" {
  description = "The name tag of the tgw attachment"
  value       = var.name
}