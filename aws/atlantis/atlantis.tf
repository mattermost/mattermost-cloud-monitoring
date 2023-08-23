resource "aws_iam_role" "atlantis" {
  name = "atlantis"

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

resource "aws_security_group" "atlantis-sg" {
  description = "atlatis-sg"
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "gitlab"
    from_port   = 4141
    protocol    = "tcp"
    to_port     = 4141
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "gitlab"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "gitlab"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
  ingress {
    cidr_blocks = [
      "10.247.4.47/32",
      "10.247.0.6/32",
      "10.247.16.6/32",
    ]
    from_port = 4141
    protocol  = "tcp"
    to_port   = 4141

  }

}
resource "aws_iam_instance_profile" "atlantis-instance-profile" {
  name = "atlantis"
  role = aws_iam_role.atlantis.name
}

resource "aws_launch_template" "atlantis-launch-template" {
  iam_instance_profile {
    name = aws_iam_instance_profile.atlantis-instance-profile.name
  }
  image_id                    = var.ami_id
  instance_type               = var.instance_type
  name_prefix                 = var.deployment_name
  security_groups             = var.security_groups
  associate_public_ip_address = false
  key_name                    = var.key_name

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.volume_size
      delete_on_termination = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "atlantis-asg" {
  desired_capacity = var.desired_capacity
  launch_template {
    id      = aws_launch_template.atlantis-launch-template.id
    version = aws_launch_template.atlantis-launch-template.latest_version
  }
  max_size             = var.max_size
  min_size             = var.min_size
  name                 = "${var.atlantis_deployment_name}-atlantis-asg"
  vpc_zone_identifier  = [var.subnet_id]
  termination_policies = ["OldestInstance"]

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "Atlantis"
  }

  tag {
    key                 = "Environment"
    propagate_at_launch = true
    value               = var.environment
  }
}
