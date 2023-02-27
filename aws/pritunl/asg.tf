resource "aws_launch_template" "pritunl_lt" {
  count         = 2
  name          = "${var.name}-lt-${count.index}"
  image_id      = data.aws_ami.ubuntu_image.id
  instance_type = var.instance_type_for_lt
  user_data     = base64encode(templatefile("${path.module}/userdata.sh", { mongodb_uri = var.mongodb_uri }))

  block_device_mappings {
    device_name = "/dev/xvdb"

    ebs {
      volume_size = var.volume_size
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.pr.name
  }

  network_interfaces {
    delete_on_termination = false
    network_interface_id  = var.fixed_eni[count.index]
  }

  tags = merge(
    {
      "Name" = "${var.name}-lt-${count.index}"
    },
    local.default_tags,
  )

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      {
        "Name" = "${var.name}-app"
      },
      local.default_tags,
    )
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(
      {
        "Name" = "${var.name}-volume"
      },
      local.default_tags,
    )
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "pritunl_app" {
  count = 2
  name  = "${var.name}-app-${count.index}"

  launch_template {
    id      = aws_launch_template.pritunl_lt[count.index].id
    version = "$Latest"
  }

  min_size           = var.pritunl_app_count
  max_size           = var.pritunl_app_count
  health_check_type  = "EC2" // Need to be changed to ELB 
  availability_zones = [var.az_list[count.index]]

  target_group_arns = [
    aws_lb_target_group.pritunl_nlb_tg_webui.arn,
    aws_lb_target_group.pritunl_nlb_tg_vpn.arn,
    aws_lb_target_group.pritunl_nlb_tg_vpn_1.arn,
    aws_lb_target_group.pritunl_nlb_tg_vpn_2.arn,
    aws_lb_target_group.pritunl_nlb_tg_http.arn
  ]


  lifecycle {
    create_before_destroy = true
  }
}
