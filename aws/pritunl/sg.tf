resource "aws_security_group" "pritunl_asg_sg" {
  name        = "${var.name}-asg-sg"
  description = "SG for Pritunl AutoScaling Group"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      "Name" = "${var.name}-asg-sg"
    },
    local.default_tags,
  )
}



resource "aws_security_group_rule" "pritunl_asg_inbound_webui" {
  security_group_id = aws_security_group.pritunl_asg_sg.id
  description       = "all inbound at 443"
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pritunl_asg_inbound_http" {
  security_group_id = aws_security_group.pritunl_asg_sg.id
  description       = "all inbound at 80"
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pritunl_asg_inbound_vpn" {
  security_group_id = aws_security_group.pritunl_asg_sg.id
  description       = "all inbound from 1191 to 1199"
  type              = "ingress"
  from_port         = "1191"
  to_port           = "1199"
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pritunl_all_outbound" {
  security_group_id = aws_security_group.pritunl_asg_sg.id
  description       = "all outbound"
  type              = "egress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
