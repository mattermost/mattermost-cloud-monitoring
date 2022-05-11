resource "aws_internet_gateway" "internet_gtw" {
  for_each = toset(var.vpc_cidrs)

  vpc_id = data.aws_vpc.vpc_ids[each.value]["id"]
  tags = merge(
    {
      "Name" = format("%s-%s", var.name, join("", split(".", split("/", each.value)[0]))),
    },
    var.tags
  )
}
