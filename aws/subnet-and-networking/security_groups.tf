locals {
  dev            = var.environment == "dev" ? true : ""
  test           = var.environment == "test" ? true : ""
  prod           = var.environment != "dev" && var.environment != "test" ? false : ""
  is_dev_or_test = coalesce(local.dev, local.test, local.prod)
}
resource "aws_security_group" "master_sg" {
  for_each = toset(var.vpc_cidrs)

  name        = format("%s-%s-master-sg", var.name, join("", split(".", split("/", each.value)[0])))
  description = "Master Nodes Security Group"
  vpc_id      = data.aws_vpc.vpc_ids[each.value]["id"]

  tags = merge(
    {
      "Name"     = format("%s-%s-master-sg", var.name, join("", split(".", split("/", each.value)[0]))),
      "NodeType" = "master"
    },
    var.tags
  )
}

resource "aws_security_group" "worker_sg" {
  for_each = toset(var.vpc_cidrs)

  name        = format("%s-%s-worker-sg", var.name, join("", split(".", split("/", each.value)[0])))
  description = "Worker Nodes Security Group"
  vpc_id      = data.aws_vpc.vpc_ids[each.value]["id"]

  tags = merge(
    {
      "Name"     = format("%s-%s-worker-sg", var.name, join("", split(".", split("/", each.value)[0]))),
      "NodeType" = "worker"
    },
    var.tags
  )
}

resource "aws_security_group" "calls_sg" {
  for_each = toset(var.vpc_cidrs)

  name        = format("%s-%s-calls-sg", var.name, join("", split(".", split("/", each.value)[0])))
  description = "Calls Nodes Security Group"
  vpc_id      = data.aws_vpc.vpc_ids[each.value]["id"]

  tags = merge(
    {
      "Name"     = format("%s-%s-calls-sg", var.name, join("", split(".", split("/", each.value)[0]))),
      "NodeType" = "calls"
    },
    var.tags
  )
}

resource "aws_security_group" "db_sg" {
  for_each = toset(var.vpc_cidrs)

  name        = format("%s-%s-db-sg", var.name, join("", split(".", split("/", each.value)[0])))
  description = "RDS Database Security Group"
  vpc_id      = data.aws_vpc.vpc_ids[each.value]["id"]
  tags = merge(
    {
      "Name"                                = format("%s-%s-db-sg", var.name, join("", split(".", split("/", each.value)[0]))),
      "MattermostCloudInstallationDatabase" = "MySQL/Aurora"
    },
    var.tags
  )
}

# PostgreSQL database security group
resource "aws_security_group" "db_sg_postgresql" {
  for_each = toset(var.vpc_cidrs)

  name        = format("%s-%s-db-postgresql-sg", var.name, join("", split(".", split("/", each.value)[0])))
  description = "RDS Database PostgreSQL Security Group"
  vpc_id      = data.aws_vpc.vpc_ids[each.value]["id"]
  tags = merge(
    {
      "Name"                                = format("%s-%s-db-sg", var.name, join("", split(".", split("/", each.value)[0]))),
      "MattermostCloudInstallationDatabase" = "PostgreSQL/Aurora"
    },
    var.tags
  )
}

# Master Rules
resource "aws_security_group_rule" "master_egress" {
  for_each = toset(var.vpc_cidrs)

  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound Traffic"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.master_sg[each.value]["id"]
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "master_ingress_worker" {
  for_each = toset(var.vpc_cidrs)

  source_security_group_id = aws_security_group.worker_sg[each.value]["id"]
  description              = "Ingress Traffic from Worker Nodes"
  from_port                = 443
  protocol                 = "TCP"
  security_group_id        = aws_security_group.master_sg[each.value]["id"]
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "master_ingress_teleport" {
  for_each = toset(var.vpc_cidrs)

  type              = "ingress"
  from_port         = 3022
  to_port           = 3022
  protocol          = "tcp"
  cidr_blocks       = var.teleport_cidr
  security_group_id = aws_security_group.master_sg[each.value]["id"]
}

# Worker Rules
resource "aws_security_group_rule" "worker_egress" {
  for_each = toset(var.vpc_cidrs)

  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound Traffic"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.worker_sg[each.value]["id"]
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "worker_ingress_worker" {
  for_each = toset(var.vpc_cidrs)

  self              = true
  description       = "Ingress Traffic from Worker Nodes"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.worker_sg[each.value]["id"]
  to_port           = 0
  type              = "ingress"
}

resource "aws_security_group_rule" "worker_ingress_master" {
  for_each = toset(var.vpc_cidrs)

  source_security_group_id = aws_security_group.master_sg[each.value]["id"]
  description              = "Ingress Traffic from Master Nodes"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.worker_sg[each.value]["id"]
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "worker_ingress_teleport" {
  for_each = toset(var.vpc_cidrs)

  type              = "ingress"
  from_port         = 3022
  to_port           = 3022
  protocol          = "tcp"
  cidr_blocks       = var.teleport_cidr
  security_group_id = aws_security_group.worker_sg[each.value]["id"]
}

# Calls Rules
resource "aws_security_group_rule" "calls_egress" {
  for_each = toset(var.vpc_cidrs)

  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound Traffic"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.calls_sg[each.value]["id"]
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "calls_ingress_rtcd" {
  for_each = toset(var.vpc_cidrs)

  cidr_blocks       = ["0.0.0.0/0"]
  description       = "UDP RTCD Port"
  from_port         = 8443
  protocol          = "udp"
  security_group_id = aws_security_group.calls_sg[each.value]["id"]
  to_port           = 8443
  type              = "ingress"
}

resource "aws_security_group_rule" "calls_ingress_teleport" {
  for_each = toset(var.vpc_cidrs)

  type              = "ingress"
  description       = "Teleport SSH Access"
  from_port         = 3022
  to_port           = 3022
  protocol          = "tcp"
  cidr_blocks       = var.teleport_cidr
  security_group_id = aws_security_group.calls_sg[each.value]["id"]
}

# DB Rules
resource "aws_security_group_rule" "db_ingress_worker" {
  for_each = toset(var.vpc_cidrs)

  source_security_group_id = aws_security_group.worker_sg[each.value]["id"]
  description              = "Ingress Traffic from Worker Nodes"
  from_port                = 3306
  protocol                 = "TCP"
  security_group_id        = aws_security_group.db_sg[each.value]["id"]
  to_port                  = 3306
  type                     = "ingress"
}

resource "aws_security_group_rule" "db_ingress_worker_command_control" {
  for_each = toset(var.vpc_cidrs)

  cidr_blocks       = var.command_and_control_private_subnet_cidrs
  description       = "Ingress Traffic from Command and Control Private Subnets"
  from_port         = 3306
  protocol          = "TCP"
  security_group_id = aws_security_group.db_sg[each.value]["id"]
  to_port           = 3306
  type              = "ingress"
}

resource "aws_security_group_rule" "developers_vpn_access" {
  for_each = local.is_dev_or_test ? toset(var.vpc_cidrs) : []

  cidr_blocks       = var.vpn_cidrs
  description       = "Ingress Traffic from VPN cidrs"
  from_port         = 3306
  protocol          = "TCP"
  security_group_id = aws_security_group.db_sg[each.value]["id"]
  to_port           = 3306
  type              = "ingress"
}

# PostgreSQL DB Rules
resource "aws_security_group_rule" "db_ingress_worker_postgresql" {
  for_each = toset(var.vpc_cidrs)

  source_security_group_id = aws_security_group.worker_sg[each.value]["id"]
  description              = "Ingress Traffic from Worker Nodes"
  from_port                = 5432
  protocol                 = "TCP"
  security_group_id        = aws_security_group.db_sg_postgresql[each.value]["id"]
  to_port                  = 5432
  type                     = "ingress"
}

resource "aws_security_group_rule" "db_ingress_worker_command_control_postgresql" {
  for_each = toset(var.vpc_cidrs)

  cidr_blocks       = var.command_and_control_private_subnet_cidrs
  description       = "Ingress Traffic from Command and Control Private Subnets"
  from_port         = 5432
  protocol          = "TCP"
  security_group_id = aws_security_group.db_sg_postgresql[each.value]["id"]
  to_port           = 5432
  type              = "ingress"
}

resource "aws_security_group_rule" "developers_vpn_access_postgresql" {
  for_each = local.is_dev_or_test ? toset(var.vpc_cidrs) : []

  cidr_blocks       = var.vpn_cidrs
  description       = "Ingress Traffic from VPN cidrs"
  from_port         = 5432
  protocol          = "TCP"
  security_group_id = aws_security_group.db_sg_postgresql[each.value]["id"]
  to_port           = 5432
  type              = "ingress"
}
