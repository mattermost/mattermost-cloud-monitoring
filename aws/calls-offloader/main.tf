terraform {
  required_version = ">= 1.1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = ">= 3.55"
    }
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
    Name    = "Call Offloader SG"
    Created = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_instance" "call_offloader" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id

  vpc_security_group_ids      = [aws_security_group.calls_offloader.id]

  tags = {
    Name    = "Call Offloader"
    Created = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
  }
}
