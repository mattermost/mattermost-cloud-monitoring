terraform {
  required_version = ">= 1.1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.61.0"
    }
  }
}

resource "aws_key_pair" "calls_offloader" {
  key_name   = "calls_offloader-${var.environment}"
  public_key = var.public_key

  tags = {
    Name = "Call Offloader ${var.environment} Key"
  }
}

resource "aws_security_group" "calls_offloader" {
  name                   = "calls_offloader_sg"
  description            = "Allow worker nodes access to Calls Offloader Service"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  ingress {
    from_port   = 4545
    to_port     = 4545
    protocol    = "tcp"
    cidr_blocks = var.cloud_vpn_cidr
    description = "cloud VPN"
  }

  ingress {
    from_port   = 4545
    to_port     = 4545
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_block
    description = "VPC internal ingress - Load Balancer"
  }

  ingress {
    from_port       = 4545
    to_port         = 4545
    protocol        = "tcp"
    security_groups = var.vpc_worker_sg_id
    description     = "Worker Nodes Access"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.teleport_cidr
    description = "teleport"
  }

  ingress {
    from_port   = 3022
    to_port     = 3022
    protocol    = "tcp"
    cidr_blocks = var.teleport_cidr
    description = "teleport"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Call Offloader SG"
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_launch_template" "calls_offloader" {
  image_id      = var.ami_id
  instance_type = var.instance_type
  name_prefix   = "calls-offloader-"
  key_name      = aws_key_pair.calls_offloader.key_name

  network_interfaces {
    security_groups             = [aws_security_group.calls_offloader.id]
    associate_public_ip_address = false
  }


  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 100
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "calls_offloader" {
  desired_capacity     = var.min_size
  max_size             = var.max_size
  min_size             = var.min_size
  name                 = "calls-offloader-asg"
  vpc_zone_identifier  = var.subnet_ids
  termination_policies = ["OldestInstance"]

  launch_template {
    id      = aws_launch_template.calls_offloader.id
    version = aws_launch_template.calls_offloader.latest_version
  }

  target_group_arns = [
    aws_lb_target_group.calls_offloader.arn
  ]

  tag {
    key                 = "Name"
    value               = "Call Offloader"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }


  lifecycle {
    create_before_destroy = true
  }
}
