resource "aws_vpc_endpoint" "s3_us_east_1" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.us-east-1.s3"

  tags = {
    VpcID = var.vpc_id
  }
}

resource "aws_vpc_endpoint_route_table_association" "public_s3_endpoint" {
  for_each = toset(var.public_route_table_ids)

  vpc_endpoint_id = aws_vpc_endpoint.s3_us_east_1.id
  route_table_id  = each.value
}

resource "aws_vpc_endpoint_route_table_association" "private_s3_endpoint" {
  for_each = toset(var.private_route_table_ids)

  vpc_endpoint_id = aws_vpc_endpoint.s3_us_east_1.id
  route_table_id  = each.value
}
