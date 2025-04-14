resource "aws_security_group" "pexip_conference_sg" {
  name        = "${var.name}-conference-sg"
  description = "Security group for Pexip conferencing nodes"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name" = "${var.name}-conference-sg"
    },
  )
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
}

resource "aws_security_group" "pexip_management_elb_sg" {
  name        = "${var.name}-management-elb-sg"
  description = "Security group for Pexip management ELB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-management-elb-sg"
  }
}

resource "aws_security_group" "pexip_conference_elb_sg" {
  name        = "${var.name}-conference-elb-sg"
  description = "Security group for Pexip Conference ELB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-conference-elb-sg"
  }
}

# Conference SG rules
resource "aws_security_group_rule" "pexip_conference_udp_ports" {
  type              = "ingress"
  from_port         = 40000
  to_port           = 49999
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pexip_conference_sg.id
  description       = "Endpoint / call control system / Skype for Business / Lync system / Connect app"
}

resource "aws_security_group_rule" "pexip_conference_vpn_access" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.vpn_ips
  security_group_id = aws_security_group.pexip_conference_sg.id
  description       = "VPN access"
}

resource "aws_security_group_rule" "pexip_conference_from_management" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [for ip in var.management_private_ips : "${ip}/32"]
  security_group_id = aws_security_group.pexip_conference_sg.id
  description       = "Allow all access from management private IP"
}

resource "aws_security_group_rule" "pexip_conference_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pexip_conference_sg.id
  description       = "Allow all outbound traffic"
}

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

# Management SG rules
resource "aws_security_group_rule" "pexip_management_initial_config" {
  count             = var.initial_configuration ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.vpn_ips
  security_group_id = aws_security_group.pexip_management_sg.id
  description       = "initial configuration of Pexip management node"
}

resource "aws_security_group_rule" "pexip_management_from_conference" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [for node in var.conference_nodes : "${node.private_ip}/32"]
  security_group_id = aws_security_group.pexip_management_sg.id
  description       = "Allow all access from conference private IPs"
}

resource "aws_security_group_rule" "pexip_management_from_elb_443" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pexip_management_elb_sg.id
  security_group_id        = aws_security_group.pexip_management_sg.id
  description              = "HTTPS from ELB"
}

resource "aws_security_group_rule" "pexip_management_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pexip_management_sg.id
  description       = "Allow all outbound traffic"
}

# Management ELB SG rules
resource "aws_security_group_rule" "pexip_management_elb_https_vpn" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.vpn_ips
  security_group_id = aws_security_group.pexip_management_elb_sg.id
  description       = "HTTPS access from VPN"
}

resource "aws_security_group_rule" "pexip_management_elb_to_mgmt_443" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pexip_management_sg.id
  security_group_id        = aws_security_group.pexip_management_elb_sg.id
  description              = "HTTPS to management nodes"
}

resource "aws_security_group_rule" "pexip_management_elb_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pexip_management_elb_sg.id
  description       = "Allow all outbound traffic"
}

# Conference ELB SG rules
resource "aws_security_group_rule" "pexip_conference_elb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pexip_conference_elb_sg.id
  description       = "HTTPS access"
}

resource "aws_security_group_rule" "pexip_conference_elb_sip" {
  type              = "ingress"
  from_port         = 5060
  to_port           = 5060
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pexip_conference_elb_sg.id
  description       = "SIP access"
}

resource "aws_security_group_rule" "pexip_conference_elb_sip_tls" {
  type              = "ingress"
  from_port         = 5061
  to_port           = 5061
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pexip_conference_elb_sg.id
  description       = "SIP TLS access"
}

resource "aws_security_group_rule" "pexip_conference_elb_bootstrap" {
  count             = var.initial_configuration ? 1 : 0
  type              = "ingress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pexip_conference_elb_sg.id
  description       = "upload configuration/bootstrap port"
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

resource "aws_security_group_rule" "pexip_conference_elb_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pexip_conference_elb_sg.id
  description       = "Allow all outbound traffic"
}
