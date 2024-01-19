resource "aws_autoscaling_lifecycle_hook" "bind_lifecycle_hook" {
  name                   = "bind-lifecycle-hook"
  autoscaling_group_name = aws_autoscaling_group.bind_autoscale.name
  default_result         = "ABANDON"
  heartbeat_timeout      = 60
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"
}

resource "aws_network_interface" "bind_network_interface" {
  count           = length(var.subnet_ids) - 1
  subnet_id       = var.subnet_ids[count.index]
  private_ips     = [var.private_ips[count.index]]
  security_groups = [aws_security_group.bind_sg.id]

  tags = {
    BindServer = "true"
  }
}

# The SG of the bind server
resource "aws_security_group" "bind_sg" {
  name        = "Bind Server SG"
  description = "The security group of the Bind server"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = var.cidr_blocks
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  ingress {
    from_port   = 9153
    to_port     = 9153
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.vpn_cidr
  }

  ingress {
    from_port   = 3022
    to_port     = 3022
    protocol    = "tcp"
    cidr_blocks = var.teleport_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
