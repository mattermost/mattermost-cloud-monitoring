resource "aws_security_group" "pexip_conference_sg" {
  name        = "${var.name}-conference-sg"
  description = "Security group for Pexip conferencing nodes"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name" = "${var.name}-conference-sg"
    },
  )

  ingress {
    from_port   = 40000
    to_port     = 49999
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Endpoint / call control system / Skype for Business / Lync system / Connect app"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.vpn_ips
    description = "VPN access"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [for ip in var.management_private_ips : "${ip}/32"]
    description = "Allow all access from management private IP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "-"
  }
}

resource "aws_security_group" "pexip_management_sg" {
  name        = "${var.name}-management-sg"
  description = "Security group for Pexip management nodes"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name" = "${var.name}-management-sg"
    },
  )

  dynamic "ingress" {
    for_each = var.initial_configuration ? [1] : []
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = var.vpn_ips
      description = "initial configuration of Pexip management node"
    }
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [for node in var.conference_nodes : "${node.private_ip}/32"]
    description = "Allow all access from conference private IPs"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "-"
  }
}

resource "aws_security_group" "pexip_management_elb_sg" {
  name        = "${var.name}-management-elb-sg"
  description = "Security group for Pexip management ELB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.vpn_ips
    description = "HTTPS access from VPN"
  }

  tags = {
    Name = "${var.name}-management-elb-sg"
  }
}

resource "aws_security_group" "pexip_conference_elb_sg" {
  name        = "${var.name}-conference-elb-sg"
  description = "Security group for Pexip Conference ELB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access"
  }

  ingress {
    from_port   = 5060
    to_port     = 5060
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SIP access"
  }

  ingress {
    from_port   = 5061
    to_port     = 5061
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SIP TLS access"
  }

  dynamic "ingress" {
    for_each = var.initial_configuration ? [1] : []
    content {
      from_port   = 8443
      to_port     = 8443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "upload configuration/bootstrap port"
    }
  }

  tags = {
    Name = "${var.name}-conference-elb-sg"
  }
}

# Separate security group rules to avoid circular dependency
# Conference SG ingress rules
resource "aws_security_group_rule" "pexip_conference_from_elb_443" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pexip_conference_elb_sg.id
  security_group_id        = aws_security_group.pexip_conference_sg.id
  description              = "UI access from ELB"
}

resource "aws_security_group_rule" "pexip_conference_from_elb_5061" {
  type                     = "ingress"
  from_port                = 5061
  to_port                  = 5061
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pexip_conference_elb_sg.id
  security_group_id        = aws_security_group.pexip_conference_sg.id
  description              = "SIP/TLS from ELB"
}

resource "aws_security_group_rule" "pexip_conference_from_elb_8443" {
  count                    = var.initial_configuration ? 1 : 0
  type                     = "ingress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pexip_conference_elb_sg.id
  security_group_id        = aws_security_group.pexip_conference_sg.id
  description              = "upload configuration/bootstrap port from ELB"
}

# Management SG ingress rule
resource "aws_security_group_rule" "pexip_management_from_elb_443" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pexip_management_elb_sg.id
  security_group_id        = aws_security_group.pexip_management_sg.id
  description              = "HTTPS from ELB"
}

# ELB egress rules
resource "aws_security_group_rule" "pexip_management_elb_to_mgmt_443" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pexip_management_sg.id
  security_group_id        = aws_security_group.pexip_management_elb_sg.id
  description              = "HTTPS to management nodes"
}

resource "aws_security_group_rule" "pexip_conference_elb_to_conf_443" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pexip_conference_sg.id
  security_group_id        = aws_security_group.pexip_conference_elb_sg.id
  description              = "HTTPS to conference nodes"
}

resource "aws_security_group_rule" "pexip_conference_elb_to_conf_5061" {
  type                     = "egress"
  from_port                = 5061
  to_port                  = 5061
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pexip_conference_sg.id
  security_group_id        = aws_security_group.pexip_conference_elb_sg.id
  description              = "SIP TLS to conference nodes"
}

resource "aws_security_group_rule" "pexip_conference_elb_to_conf_8443" {
  count                    = var.initial_configuration ? 1 : 0
  type                     = "egress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pexip_conference_sg.id
  security_group_id        = aws_security_group.pexip_conference_elb_sg.id
  description              = "Configuration/bootstrap to conference nodes"
}
