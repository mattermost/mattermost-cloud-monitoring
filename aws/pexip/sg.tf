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
    from_port   = 5060
    to_port     = 5060
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SIP"
  }

  ingress {
    from_port   = 40000
    to_port     = 49999
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Endpoint / call control system / Skype for Business / Lync system / Connect app"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "UI access"
  }

  ingress {
    from_port   = 5061
    to_port     = 5061
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SIP/TLS"
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
    cidr_blocks = [for ip in var.conference_private_ips : "${ip}/32"]
    description = "Allow all access from conference private IP"
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.pexip_management_elb_sg.id]
    description     = "HTTPS from ELB"
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.name}-conference-elb-sg"
  }
}
