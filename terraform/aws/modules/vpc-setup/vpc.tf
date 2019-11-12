
resource "aws_vpc" "vpc_creation" {
  for_each = toset(var.vpc_cidrs)

  cidr_block                       = each.value
  enable_dns_hostnames             = var.enable_dns_hostnames
  tags = merge(
    {
      "Name" = format("%s-%s", var.name, join("", split(".", split("/", each.value)[0]))),
      "Available" = "true"
      "Size" = split("/", each.value)[1]
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [
      # Ignore changes to tag Available
      tags["Available"],
    ]
  }
}



