locals {
  flattened_routes = flatten([
    for vpc_cidr, routes in var.vpc_cidrs_tgw_routes : [
      for route in routes : {
        vpc_cidr       = vpc_cidr
        route_cidr     = route
      }
    ]
  ])
}

resource "aws_route_table" "public" {
  for_each = var.single_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc_id   = each.value != "" ? data.aws_vpc.vpc_ids[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-public-rtb", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}

resource "aws_route_table" "public_1a" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc_id   = each.value != "" ? data.aws_vpc.vpc_ids[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-public-rtb-1a", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}

resource "aws_route_table" "public_1b" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc_id   = each.value != "" ? data.aws_vpc.vpc_ids[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-public-rtb-1b", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}

resource "aws_route_table" "public_1c" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc_id   = each.value != "" ? data.aws_vpc.vpc_ids[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-public-rtb-1c", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}

resource "aws_route_table" "public_1d" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc_id   = each.value != "" ? data.aws_vpc.vpc_ids[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-public-rtb-1d", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}

resource "aws_route_table" "public_1e" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc_id   = each.value != "" ? data.aws_vpc.vpc_ids[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-public-rtb-1e", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}

resource "aws_route_table" "public_1f" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc_id   = each.value != "" ? data.aws_vpc.vpc_ids[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-public-rtb-1f", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}

resource "aws_route_table" "private" {
  for_each = var.single_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc_id   = each.value != "" ? data.aws_vpc.vpc_ids[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-private-rtb", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}

resource "aws_route_table" "private_1a" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc_id   = each.value != "" ? data.aws_vpc.vpc_ids[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-private-rtb-1a", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}

resource "aws_route_table" "private_1b" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc_id   = each.value != "" ? data.aws_vpc.vpc_ids[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-private-rtb-1b", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}

resource "aws_route_table" "private_1c" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc_id   = each.value != "" ? data.aws_vpc.vpc_ids[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-private-rtb-1c", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}

resource "aws_route_table" "private_1d" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc_id   = each.value != "" ? data.aws_vpc.vpc_ids[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-private-rtb-1d", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}

resource "aws_route_table" "private_1e" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc_id   = each.value != "" ? data.aws_vpc.vpc_ids[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-private-rtb-1e", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}

resource "aws_route_table" "private_1f" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  vpc_id   = each.value != "" ? data.aws_vpc.vpc_ids[each.value]["id"] : ""
  tags = merge(
    {
      "Name" = format("%s-%s-private-rtb-1f", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}

resource "aws_route" "public_internet_gateway" {
  for_each               = var.single_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  route_table_id         = aws_route_table.public[each.value]["id"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = each.value != "" ? aws_internet_gateway.internet_gtw[each.value]["id"] : ""

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "public_internet_gateway_1a" {
  for_each               = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  route_table_id         = aws_route_table.public_1a[each.value]["id"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = each.value != "" ? aws_internet_gateway.internet_gtw[each.value]["id"] : ""

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "public_internet_gateway_1b" {
  for_each               = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  route_table_id         = aws_route_table.public_1b[each.value]["id"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = each.value != "" ? aws_internet_gateway.internet_gtw[each.value]["id"] : ""

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "public_internet_gateway_1c" {
  for_each               = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  route_table_id         = aws_route_table.public_1c[each.value]["id"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = each.value != "" ? aws_internet_gateway.internet_gtw[each.value]["id"] : ""

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "public_internet_gateway_1d" {
  for_each               = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  route_table_id         = aws_route_table.public_1d[each.value]["id"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = each.value != "" ? aws_internet_gateway.internet_gtw[each.value]["id"] : ""

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "public_internet_gateway_1e" {
  for_each               = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  route_table_id         = aws_route_table.public_1d[each.value]["id"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = each.value != "" ? aws_internet_gateway.internet_gtw[each.value]["id"] : ""

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "public_internet_gateway_1f" {
  for_each               = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  route_table_id         = aws_route_table.public_1f[each.value]["id"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = each.value != "" ? aws_internet_gateway.internet_gtw[each.value]["id"] : ""

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_nat_gateway" {
  for_each               = var.single_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  route_table_id         = aws_route_table.private[each.value]["id"]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gtws[each.value]["id"]

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_nat_gateway_1a" {
  for_each               = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  route_table_id         = aws_route_table.private_1a[each.value]["id"]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gtw_1a[each.value]["id"]

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_nat_gateway_1b" {
  for_each               = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  route_table_id         = aws_route_table.private_1b[each.value]["id"]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gtw_1b[each.value]["id"]

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_nat_gateway_1c" {
  for_each               = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  route_table_id         = aws_route_table.private_1c[each.value]["id"]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gtw_1c[each.value]["id"]

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_nat_gateway_1d" {
  for_each               = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  route_table_id         = aws_route_table.private_1d[each.value]["id"]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gtw_1d[each.value]["id"]

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_nat_gateway_1e" {
  for_each               = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  route_table_id         = aws_route_table.private_1e[each.value]["id"]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gtw_1e[each.value]["id"]

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_nat_gateway_1f" {
  for_each               = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []
  route_table_id         = aws_route_table.private_1f[each.value]["id"]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gtw_1f[each.value]["id"]

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "transit_gateway" {
  for_each = var.single_route_table_deployment == true ? { for idx, route in local.flattened_routes : "${route.vpc_cidr}-${idx}" => route } : {}
  route_table_id         = aws_route_table.private[each.value.vpc_cidr]["id"]
  destination_cidr_block = each.value.route_cidr
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "transit_gateway_1a" {
  for_each               = var.multi_route_table_deployment == true ? { for idx, route in local.flattened_routes : "${route.vpc_cidr}-${idx}" => route } : {}
  route_table_id         = aws_route_table.private_1a[each.value.vpc_cidr]["id"]
  destination_cidr_block = each.value.route_cidr
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "transit_gateway_1b" {
  for_each               = var.multi_route_table_deployment == true ? { for idx, route in local.flattened_routes : "${route.vpc_cidr}-${idx}" => route } : {}
  route_table_id         = aws_route_table.private_1b[each.value.vpc_cidr]["id"]
  destination_cidr_block = each.value.route_cidr
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "transit_gateway_1c" {
  for_each               = var.multi_route_table_deployment == true ? { for idx, route in local.flattened_routes : "${route.vpc_cidr}-${idx}" => route } : {}
  route_table_id         = aws_route_table.private_1c[each.value.vpc_cidr]["id"]
  destination_cidr_block = each.value.route_cidr
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "transit_gateway_1d" {
  for_each               = var.multi_route_table_deployment == true ? { for idx, route in local.flattened_routes : "${route.vpc_cidr}-${idx}" => route } : {}
  route_table_id         = aws_route_table.private_1d[each.value.vpc_cidr]["id"]
  destination_cidr_block = each.value.route_cidr
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "transit_gateway_1e" {
  for_each               = var.multi_route_table_deployment == true ? { for idx, route in local.flattened_routes : "${route.vpc_cidr}-${idx}" => route } : {}
  route_table_id         = aws_route_table.private_1e[each.value.vpc_cidr]["id"]
  destination_cidr_block = each.value.route_cidr
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "transit_gateway_1f" {
  for_each               = var.multi_route_table_deployment == true ? { for idx, route in local.flattened_routes : "${route.vpc_cidr}-${idx}" => route } : {}
  route_table_id         = aws_route_table.private_1f[each.value.vpc_cidr]["id"]
  destination_cidr_block = each.value.route_cidr
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "transit_gateway_public" {
  for_each               = var.single_route_table_deployment == true ? { for idx, route in local.flattened_routes : "${route.vpc_cidr}-${idx}" => route } : {}
  route_table_id         = aws_route_table.public[each.value.vpc_cidr]["id"]
  destination_cidr_block = each.value.route_cidr
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "transit_gateway_public_1a" {
  for_each               = var.multi_route_table_deployment == true ? { for idx, route in local.flattened_routes : "${route.vpc_cidr}-${idx}" => route } : {}
  route_table_id         = aws_route_table.public_1a[each.value.vpc_cidr]["id"]
  destination_cidr_block = each.value.route_cidr
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "transit_gateway_public_1b" {
  for_each               = var.multi_route_table_deployment == true ? { for idx, route in local.flattened_routes : "${route.vpc_cidr}-${idx}" => route } : {}
  route_table_id         = aws_route_table.public_1b[each.value.vpc_cidr]["id"]
  destination_cidr_block = each.value.route_cidr
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "transit_gateway_public_1c" {
  for_each               = var.multi_route_table_deployment == true ? { for idx, route in local.flattened_routes : "${route.vpc_cidr}-${idx}" => route } : {}
  route_table_id         = aws_route_table.public_1c[each.value.vpc_cidr]["id"]
  destination_cidr_block = each.value.route_cidr
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "transit_gateway_public_1d" {
  for_each               = var.multi_route_table_deployment == true ? { for idx, route in local.flattened_routes : "${route.vpc_cidr}-${idx}" => route } : {}
  route_table_id         = aws_route_table.public_1d[each.value.vpc_cidr]["id"]
  destination_cidr_block = each.value.route_cidr
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "transit_gateway_public_1e" {
  for_each               = var.multi_route_table_deployment == true ? { for idx, route in local.flattened_routes : "${route.vpc_cidr}-${idx}" => route } : {}
  route_table_id         = aws_route_table.public_1e[each.value.vpc_cidr]["id"]
  destination_cidr_block = each.value.route_cidr
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route" "transit_gateway_public_1f" {
  for_each               = var.multi_route_table_deployment == true ? { for idx, route in local.flattened_routes : "${route.vpc_cidr}-${idx}" => route } : {}
  route_table_id         = aws_route_table.public_1f[each.value.vpc_cidr]["id"]
  destination_cidr_block = each.value.route_cidr
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment]
}

resource "aws_route_table_association" "private_1a" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.private_1a[each.value]["id"]
  route_table_id = var.multi_route_table_deployment == true ? aws_route_table.private_1a[each.value]["id"] : aws_route_table.private[each.value]["id"]
}

resource "aws_route_table_association" "private_1b" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.private_1b[each.value]["id"]
  route_table_id = var.multi_route_table_deployment == true ? aws_route_table.private_1b[each.value]["id"] : aws_route_table.private[each.value]["id"]
}

resource "aws_route_table_association" "private_1c" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.private_1c[each.value]["id"]
  route_table_id = var.multi_route_table_deployment == true ? aws_route_table.private_1c[each.value]["id"] : aws_route_table.private[each.value]["id"]
}

resource "aws_route_table_association" "private_1d" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.private_1d[each.value]["id"]
  route_table_id = var.multi_route_table_deployment == true ? aws_route_table.private_1d[each.value]["id"] : aws_route_table.private[each.value]["id"]
}

resource "aws_route_table_association" "private_1e" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.private_1e[each.value]["id"]
  route_table_id = var.multi_route_table_deployment == true ? aws_route_table.private_1e[each.value]["id"] : aws_route_table.private[each.value]["id"]
}

resource "aws_route_table_association" "private_1f" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.private_1f[each.value]["id"]
  route_table_id = var.multi_route_table_deployment == true ? aws_route_table.private_1f[each.value]["id"] : aws_route_table.private[each.value]["id"]
}

resource "aws_route_table_association" "public_1a" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.public_1a[each.value]["id"]
  route_table_id = var.multi_route_table_deployment == true ? aws_route_table.public_1a[each.value]["id"] : aws_route_table.public[each.value]["id"]
}

resource "aws_route_table_association" "public_1b" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.public_1b[each.value]["id"]
  route_table_id = var.multi_route_table_deployment == true ? aws_route_table.public_1b[each.value]["id"] : aws_route_table.public[each.value]["id"]
}

resource "aws_route_table_association" "public_1c" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.public_1c[each.value]["id"]
  route_table_id = var.multi_route_table_deployment == true ? aws_route_table.public_1c[each.value]["id"] : aws_route_table.public[each.value]["id"]
}

resource "aws_route_table_association" "public_1d" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.public_1d[each.value]["id"]
  route_table_id = var.multi_route_table_deployment == true ? aws_route_table.public_1d[each.value]["id"] : aws_route_table.public[each.value]["id"]
}

resource "aws_route_table_association" "public_1e" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.public_1e[each.value]["id"]
  route_table_id = var.multi_route_table_deployment == true ? aws_route_table.public_1e[each.value]["id"] : aws_route_table.public[each.value]["id"]
}

resource "aws_route_table_association" "public_1f" {
  for_each = toset(var.vpc_cidrs)

  subnet_id      = aws_subnet.public_1f[each.value]["id"]
  route_table_id = var.multi_route_table_deployment == true ? aws_route_table.public_1f[each.value]["id"] : aws_route_table.public[each.value]["id"]
}
