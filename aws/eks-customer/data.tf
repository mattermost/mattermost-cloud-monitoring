data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {}

data "aws_route53_zone" "internal" {
  name         = "internal.${var.environment}.${var.private_domain}"
  private_zone = true
}

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

data "aws_lb" "internal" {
  tags = {
    "kubernetes.io/cluster/${module.eks.cluster_name}" = "owned"
    "kubernetes.io/service-name"                       = "nginx-internal/nginx-internal-ingress-nginx-controller"
  }

  timeouts {
    read = "20m"
  }

  depends_on = [null_resource.deploy-utilites]
}

data "aws_lb" "thanos-query-grpc" {
  tags = {
    "kubernetes.io/cluster/${module.eks.cluster_name}" = "owned"
    "kubernetes.io/service-name"                       = "prometheus/thanos-query-grpc"
  }

  timeouts {
    read = "20m"
  }

  depends_on = [null_resource.deploy-utilites]
}
