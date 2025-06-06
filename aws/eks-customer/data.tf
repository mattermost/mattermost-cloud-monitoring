data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {}

data "aws_region" "current" {}

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

  filter {
    name   = "availability-zone"
    values = [for az in data.aws_availability_zones.available.names : az if az != "us-east-1e"]
  }

  tags = {
    SubnetType = "public"
  }
}

data "aws_subnets" "private-a" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "availability-zone"
    values = [for az in data.aws_availability_zones.available.names : az if az == "us-east-1a"]
  }

  tags = {
    SubnetType = "private"
  }
}

data "aws_security_groups" "nodes" {
  filter {
    name   = "tag:Purpose"
    values = ["provisioning"]
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "tag:NodeType"
    values = ["worker"]
  }
}

data "aws_security_groups" "calls" {
  filter {
    name   = "tag:Purpose"
    values = ["provisioning"]
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "tag:NodeType"
    values = ["calls"]
  }
}

data "aws_security_groups" "control-plane" {
  filter {
    name   = "tag:Purpose"
    values = ["provisioning"]
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "tag:NodeType"
    values = ["master"]
  }
}
