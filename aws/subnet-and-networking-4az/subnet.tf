data "aws_vpc" "vpc_ids" {
  for_each = toset(var.vpc_cidrs)

  cidr_block = each.value
}


resource "aws_subnet" "private_1a" {
  for_each = toset(var.vpc_cidrs)

  vpc_id            = data.aws_vpc.vpc_ids[each.value]["id"]
  cidr_block        = cidrsubnet(cidrsubnets(each.value, 1, 1)[0], 2, 0)
  availability_zone = var.vpc_azs[0]
  tags = merge(
    {
      "Name"       = format("%s-%s-private-1a", var.name, join("", split(".", split("/", each.value)[0]))),
      "SubnetType" = "private"
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_subnet" "private_1b" {
  for_each = toset(var.vpc_cidrs)

  vpc_id            = data.aws_vpc.vpc_ids[each.value]["id"]
  cidr_block        = cidrsubnet(cidrsubnets(each.value, 1, 1)[0], 2, 1)
  availability_zone = var.vpc_azs[1]
  tags = merge(
    {
      "Name"       = format("%s-%s-private-1b", var.name, join("", split(".", split("/", each.value)[0]))),
      "SubnetType" = "private"
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_subnet" "private_1c" {
  for_each = toset(var.vpc_cidrs)

  vpc_id            = data.aws_vpc.vpc_ids[each.value]["id"]
  cidr_block        = cidrsubnet(cidrsubnets(each.value, 1, 1)[0], 2, 2)
  availability_zone = var.vpc_azs[2]
  tags = merge(
    {
      "Name"       = format("%s-%s-private-1c", var.name, join("", split(".", split("/", each.value)[0]))),
      "SubnetType" = "private"
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_subnet" "private_1d" {
  for_each = toset(var.vpc_cidrs)

  vpc_id            = data.aws_vpc.vpc_ids[each.value]["id"]
  cidr_block        = cidrsubnet(cidrsubnets(each.value, 1, 1)[0], 2, 3)
  availability_zone = var.vpc_azs[3]
  tags = merge(
    {
      "Name"       = format("%s-%s-private-1d", var.name, join("", split(".", split("/", each.value)[0]))),
      "SubnetType" = "private"
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_subnet" "public_1a" {
  for_each = toset(var.vpc_cidrs)

  vpc_id            = data.aws_vpc.vpc_ids[each.value]["id"]
  cidr_block        = cidrsubnet(cidrsubnets(each.value, 1, 1)[1], 2, 0)
  availability_zone = var.vpc_azs[0]
  tags = merge(
    {
      "Name"       = format("%s-%s-public-1a", var.name, join("", split(".", split("/", each.value)[0]))),
      "SubnetType" = "public"
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_subnet" "public_1b" {
  for_each          = toset(var.vpc_cidrs)
  vpc_id            = data.aws_vpc.vpc_ids[each.value]["id"]
  cidr_block        = cidrsubnet(cidrsubnets(each.value, 1, 1)[1], 2, 1)
  availability_zone = var.vpc_azs[1]
  tags = merge(
    {
      "Name"       = format("%s-%s-public-1b", var.name, join("", split(".", split("/", each.value)[0]))),
      "SubnetType" = "public"
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_subnet" "public_1c" {
  for_each = toset(var.vpc_cidrs)

  vpc_id            = data.aws_vpc.vpc_ids[each.value]["id"]
  cidr_block        = cidrsubnet(cidrsubnets(each.value, 1, 1)[1], 2, 2)
  availability_zone = var.vpc_azs[2]
  tags = merge(
    {
      "Name"       = format("%s-%s-public-1c", var.name, join("", split(".", split("/", each.value)[0]))),
      "SubnetType" = "public"
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_subnet" "public_1d" {
  for_each = toset(var.vpc_cidrs)

  vpc_id            = data.aws_vpc.vpc_ids[each.value]["id"]
  cidr_block        = cidrsubnet(cidrsubnets(each.value, 1, 1)[1], 2, 3)
  availability_zone = var.vpc_azs[3]
  tags = merge(
    {
      "Name"       = format("%s-%s-public-1d", var.name, join("", split(".", split("/", each.value)[0]))),
      "SubnetType" = "public"
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

