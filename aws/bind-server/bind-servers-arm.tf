resource "aws_launch_template" "bind_arm_launch_template" {
  iam_instance_profile {
    name = aws_iam_instance_profile.bind-server-instance-profile.name
  }

  name_prefix            = "${var.name}-arm-"
  image_id               = var.arm_ami
  instance_type          = var.arm_instance_type
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

resource "aws_autoscaling_group" "bind_arm_autoscale" {
  name = "autoscale-arm-bind-server"
  launch_template {
    id      = aws_launch_template.bind_arm_launch_template.id
    version = aws_launch_template.bind_arm_launch_template.latest_version
  }
  min_size                  = var.arm_min_size
  max_size                  = var.arm_max_size
  desired_capacity          = var.arm_desired_size
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
