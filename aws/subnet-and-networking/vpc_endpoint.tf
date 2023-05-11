resource "aws_vpc_endpoint" "s3_us_east_1" {
  for_each     = toset(var.vpc_cidrs)
  vpc_id       = data.aws_vpc.vpc_ids[each.value]["id"]
  service_name = "com.amazonaws.us-east-1.s3"

  tags = {
    VpcID = each.value
  }
}

resource "aws_vpc_endpoint_route_table_association" "endpoint_private" {
  for_each = var.single_route_table_deployment == true ? toset(var.vpc_cidrs) : []

  vpc_endpoint_id = aws_vpc_endpoint.s3_us_east_1[each.value]["id"]
  route_table_id  = aws_route_table.private[each.value]["id"]
}

resource "aws_vpc_endpoint_route_table_association" "endpoint_public" {
  for_each = var.single_route_table_deployment == true ? toset(var.vpc_cidrs) : []

  vpc_endpoint_id = aws_vpc_endpoint.s3_us_east_1[each.value]["id"]
  route_table_id  = aws_route_table.public[each.value]["id"]
}

resource "aws_vpc_endpoint_route_table_association" "endpoint_private_1a" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []

  vpc_endpoint_id = aws_vpc_endpoint.s3_us_east_1[each.value]["id"]
  route_table_id  = aws_route_table.private_1a[each.value]["id"]
}

resource "aws_vpc_endpoint_route_table_association" "endpoint_private_1b" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []

  vpc_endpoint_id = aws_vpc_endpoint.s3_us_east_1[each.value]["id"]
  route_table_id  = aws_route_table.private_1b[each.value]["id"]
}

resource "aws_vpc_endpoint_route_table_association" "endpoint_private_1c" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []

  vpc_endpoint_id = aws_vpc_endpoint.s3_us_east_1[each.value]["id"]
  route_table_id  = aws_route_table.private_1c[each.value]["id"]
}

resource "aws_vpc_endpoint_route_table_association" "endpoint_private_1d" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []

  vpc_endpoint_id = aws_vpc_endpoint.s3_us_east_1[each.value]["id"]
  route_table_id  = aws_route_table.private_1d[each.value]["id"]
}

resource "aws_vpc_endpoint_route_table_association" "endpoint_private_1e" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []

  vpc_endpoint_id = aws_vpc_endpoint.s3_us_east_1[each.value]["id"]
  route_table_id  = aws_route_table.private_1e[each.value]["id"]
}

resource "aws_vpc_endpoint_route_table_association" "endpoint_private_1f" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []

  vpc_endpoint_id = aws_vpc_endpoint.s3_us_east_1[each.value]["id"]
  route_table_id  = aws_route_table.private_1f[each.value]["id"]
}

resource "aws_vpc_endpoint_route_table_association" "endpoint_public_1a" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []

  vpc_endpoint_id = aws_vpc_endpoint.s3_us_east_1[each.value]["id"]
  route_table_id  = aws_route_table.public_1a[each.value]["id"]
}

resource "aws_vpc_endpoint_route_table_association" "endpoint_public_1b" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []

  vpc_endpoint_id = aws_vpc_endpoint.s3_us_east_1[each.value]["id"]
  route_table_id  = aws_route_table.public_1b[each.value]["id"] 
}

resource "aws_vpc_endpoint_route_table_association" "endpoint_public_1c" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []

  vpc_endpoint_id = aws_vpc_endpoint.s3_us_east_1[each.value]["id"]
  route_table_id  = aws_route_table.public_1c[each.value]["id"] 
}

resource "aws_vpc_endpoint_route_table_association" "endpoint_public_1d" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []

  vpc_endpoint_id = aws_vpc_endpoint.s3_us_east_1[each.value]["id"]
  route_table_id  = aws_route_table.public_1d[each.value]["id"]
}

resource "aws_vpc_endpoint_route_table_association" "endpoint_public_1e" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []

  vpc_endpoint_id = aws_vpc_endpoint.s3_us_east_1[each.value]["id"]
  route_table_id  = aws_route_table.public_1e[each.value]["id"]
}

resource "aws_vpc_endpoint_route_table_association" "endpoint_public_1f" {
  for_each = var.multi_route_table_deployment == true ? toset(var.vpc_cidrs) : []

  vpc_endpoint_id = aws_vpc_endpoint.s3_us_east_1[each.value]["id"]
  route_table_id  = aws_route_table.public_1f[each.value]["id"] 
}
