data "aws_availability_zones" "available" {}

data "aws_subnets" "private" {
    filter {
        name   = "vpc-id"
        values = [var.vpc_id]
    }

    filter {
        name   = "availability-zone"
        values = [for az in data.aws_availability_zones.available.names : az if az != "us-east-1e"]
    }

    tags = {
        SubnetType = "private"
    }
}

data "aws_subnets" "public" {
    filter {
        name   = "vpc-id"
        values = [var.vpc_id]
    }

    tags = {
        SubnetType = "public"
    }
}
