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
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.vpn_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# The ssh keypair created for the bind server
resource "aws_key_pair" "bind" {
  key_name   = "mattermost-cloud-${var.environment}-bind"
  public_key = var.ssh_key_public
}

resource "aws_launch_configuration" "bind_lauch_configuration" {
  name_prefix   = "${var.name}-"
  image_id      = var.ami
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bind_autoscale" {
  name                      = "autoscale-bind-server"
  launch_configuration      = aws_launch_configuration.bind_lauch_configuration.name
  min_size                  = 3
  max_size                  = 3
  desired_capacity          = 3
  key_name                  = aws_key_pair.bind.name
  security_groups           = [aws_security_group.bind_sg.id]
  vpc_zone_identifier       = var.subnet_ids
  default_cooldown          = 30
  health_check_grace_period = 30
  health_check_type         = "EC2"
  force_delete              = true
  termination_policies      = "OldestInstance"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "Bind-Server"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_lifecycle_hook" "bind_lifecycle_hook" {
  name                   = "bind-lifecycle-hook"
  autoscaling_group_name = aws_autoscaling_group.bind_autoscale.name
  default_result         = "ABANDON"
  heartbeat_timeout      = 60
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"
}

resource "aws_network_interface" "bind_server_1" {
  subnet_id       = var.subnet_ids[0]
  private_ips     = [var.private_ips[0]]
  security_groups = [aws_security_group.bind_sg.id]

  tags {
    key   = "BindServer"
    value = "true"
  }
}

resource "aws_network_interface" "bind_server_2" {
  subnet_id       = var.subnet_ids[1]
  private_ips     = [var.private_ips[1]]
  security_groups = [aws_security_group.bind_sg.id]

  tags {
    key   = "BindServer"
    value = "true"
  }
}

resource "aws_network_interface" "bind_server_3" {
  subnet_id       = var.subnet_ids[2]
  private_ips     = [var.private_ips[2]]
  security_groups = [aws_security_group.bind_sg.id]

  tags {
    key   = "BindServer"
    value = "true"
  }
}

resource "aws_network_interface" "bind_server_4" {
  subnet_id       = var.subnet_ids[3]
  private_ips     = [var.private_ips[3]]
  security_groups = [aws_security_group.bind_sg.id]

  tags {
    key   = "BindServer"
    value = "true"
  }
}
