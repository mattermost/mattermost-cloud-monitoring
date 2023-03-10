resource "aws_eip" "nat_eip" {
  for_each = var.single_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc = true
  tags = merge(
    {
      "Name" = format("%s-%s", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags,
  )
}

resource "aws_nat_gateway" "nat_gtws" {
  for_each = var.single_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  allocation_id = aws_eip.nat_eip[each.value]["id"]
  subnet_id     = aws_subnet.public_1a[each.value]["id"]
  tags = merge(
    {
      "Name" = format("%s-%s", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.internet_gtw]
}

resource "aws_eip" "nat_eip_1a" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc = true
  tags = merge(
    {
      "Name" = format("%s-%s-1a", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags,
  )
}

resource "aws_eip" "nat_eip_1b" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc = true
  tags = merge(
    {
      "Name" = format("%s-%s-1b", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags,
  )
}

resource "aws_eip" "nat_eip_1c" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc = true
  tags = merge(
    {
      "Name" = format("%s-%s-1c", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags,
  )
}

resource "aws_eip" "nat_eip_1d" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc = true
  tags = merge(
    {
      "Name" = format("%s-%s-1d", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags,
  )
}

resource "aws_nat_gateway" "nat_gtw_1a" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  allocation_id = aws_eip.nat_eip_1a[each.value]["id"]
  subnet_id     = each.value != "" ? aws_subnet.public_1a[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-1a", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.internet_gtw]
}

resource "aws_nat_gateway" "nat_gtw_1b" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  allocation_id = aws_eip.nat_eip_1b[each.value]["id"]
  subnet_id     = each.value != "" ? aws_subnet.public_1b[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-1b", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.internet_gtw]
}

resource "aws_nat_gateway" "nat_gtw_1c" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  allocation_id = aws_eip.nat_eip_1c[each.value]["id"]
  subnet_id     = each.value != "" ? aws_subnet.public_1c[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-1c", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.internet_gtw]
}

resource "aws_nat_gateway" "nat_gtw_1d" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  allocation_id = aws_eip.nat_eip_1d[each.value]["id"]
  subnet_id     = each.value != "" ? aws_subnet.public_1c[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-1d", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.internet_gtw]
}
