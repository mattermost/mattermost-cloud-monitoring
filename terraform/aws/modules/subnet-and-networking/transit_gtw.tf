resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  for_each = toset(var.vpc_cidrs)
  
  subnet_ids         = [
      aws_subnet.private_1a[each.value]["id"],
      aws_subnet.private_1b[each.value]["id"],
      aws_subnet.private_1c[each.value]["id"],
      aws_subnet.private_1d[each.value]["id"],
      aws_subnet.private_1e[each.value]["id"],
      aws_subnet.private_1f[each.value]["id"]
  ]
  transit_gateway_id = var.transit_gateway_id
  vpc_id = data.aws_vpc.vpc_ids[each.value]["id"]
  tags = merge(
    {
        "Name" = format("%s-%s", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}


