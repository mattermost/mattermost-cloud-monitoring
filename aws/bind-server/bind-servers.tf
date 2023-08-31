data "aws_caller_identity" "current" {}

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

# The ssh keypair created for the bind server
resource "aws_key_pair" "bind" {
  key_name   = "mattermost-cloud-${var.environment}-bind"
  public_key = var.ssh_key_public
}

resource "aws_launch_template" "bind_launch_template" {
  iam_instance_profile {
    name = aws_iam_instance_profile.bind-server-instance-profile.name
  }

  name_prefix            = "${var.name}-"
  image_id               = var.ami
  instance_type          = var.instance_type
  key_name               = "mattermost-cloud-${var.environment}-bind"
  vpc_security_group_ids = [aws_security_group.bind_sg.id]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      delete_on_termination = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Bind-Server"
    }
  }

}

resource "aws_autoscaling_group" "bind_autoscale" {
  name = "autoscale-bind-server"
  launch_template {
    id      = aws_launch_template.bind_launch_template.id
    version = aws_launch_template.bind_launch_template.latest_version
  }
  min_size                  = 3
  max_size                  = 3
  desired_capacity          = 3
  vpc_zone_identifier       = [var.subnet_ids[0], var.subnet_ids[1], var.subnet_ids[2]]
  default_cooldown          = 30
  health_check_grace_period = 30
  health_check_type         = "EC2"
  force_delete              = true
  termination_policies      = ["OldestInstance"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "Bind-Server"
    propagate_at_launch = true
  }

  depends_on = [
    aws_lambda_function.bind_server_network_attachment,
    aws_network_interface.bind_network_interface
  ]
}

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

resource "aws_iam_instance_profile" "bind-server-instance-profile" {
  name = "${var.environment}-bind-server-instance-profile"
  role = aws_iam_role.bind-server-role.name
}

resource "aws_iam_role" "bind-server-role" {
  name = "${var.environment}-bind-server-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "bind-cloudwatch-agent" {
  count = length(local.role_policy_arn)

  role       = aws_iam_role.bind-server-role.name
  policy_arn = element(local.role_policy_arn, count.index)
}
