
resource "aws_route_table" "public" {
  for_each = toset(var.vpc_cidrs)

  vpc_id = data.aws_vpc.vpc_ids[each.value]["id"]
  tags = merge(
    {
      "Name" = format("%s-%s-public-rtb", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}


resource "aws_route_table" "private" {
  for_each = toset(var.vpc_cidrs)

  vpc_id = data.aws_vpc.vpc_ids[each.value]["id"]
  tags = merge(
    {
      "Name" = format("%s-%s-private-rtb", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}

resource "aws_route" "public_internet_gateway" {
  for_each = toset(var.vpc_cidrs)

  route_table_id         = aws_route_table.public[each.value]["id"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gtw[each.value]["id"]

  timeouts {
    create = "5m"
  }
}


resource "aws_route" "private_nat_gateway" {
  for_each = toset(var.vpc_cidrs)

  route_table_id         = aws_route_table.private[each.value]["id"]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gtws[each.value]["id"]

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "transit_gateway" {
  for_each = toset(var.vpc_cidrs)

  route_table_id         = aws_route_table.private[each.value]["id"]
  destination_cidr_block = var.transit_gtw_route_destination
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "transit_gateway_public" {
  for_each = toset(var.vpc_cidrs)

  route_table_id         = aws_route_table.public[each.value]["id"]
  destination_cidr_block = var.transit_gtw_route_destination
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route_table_association" "private_1a" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.private_1a[each.value]["id"]
  route_table_id = aws_route_table.private[each.value]["id"]
}

resource "aws_route_table_association" "private_1b" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.private_1b[each.value]["id"]
  route_table_id = aws_route_table.private[each.value]["id"]
}

resource "aws_route_table_association" "private_1c" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.private_1c[each.value]["id"]
  route_table_id = aws_route_table.private[each.value]["id"]
}

resource "aws_route_table_association" "public_1a" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.public_1a[each.value]["id"]
  route_table_id = aws_route_table.public[each.value]["id"]
}

resource "aws_route_table_association" "public_1b" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.public_1b[each.value]["id"]
  route_table_id = aws_route_table.public[each.value]["id"]
}

resource "aws_route_table_association" "public_1c" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.public_1c[each.value]["id"]
  route_table_id = aws_route_table.public[each.value]["id"]
}

