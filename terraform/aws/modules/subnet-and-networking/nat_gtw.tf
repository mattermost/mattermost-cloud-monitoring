resource "aws_eip" "nat_eip" {
  for_each = toset(var.vpc_cidrs)
  
  vpc = true
  tags = merge(
    {
        "Name" = format("%s-%s", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags,
  )
}

resource "aws_nat_gateway" "nat_gtws" {
  for_each = toset(var.vpc_cidrs)

  allocation_id = aws_eip.nat_eip[each.value]["id"]
  subnet_id = aws_subnet.public_1a[each.value]["id"]
  tags = merge(
    {
        "Name" = format("%s-%s", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.internet_gtw]
}
