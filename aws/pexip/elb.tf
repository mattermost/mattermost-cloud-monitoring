resource "aws_elb" "pexip_management_elb" {
  name            = "${var.name}-management-elb"
  subnets         = [var.private_subnet_id]
  security_groups = [aws_security_group.pexip_management_elb_sg.id]
  internal        = true

  listener {
    instance_port      = 443
    instance_protocol  = "https"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.elb_ssl_certificate_arn_internal
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:443"
    interval            = 30
  }

  instances                   = [aws_instance.pexip_management.id]
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.name}-management-elb"
  }
}

resource "aws_elb" "pexip_conference_elb" {
  name            = "${var.name}-conference-elb"
  subnets         = [var.public_subnet_id]
  security_groups = [aws_security_group.pexip_conference_elb_sg.id]
  internal        = false

  listener {
    instance_port      = 443
    instance_protocol  = "https"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.elb_ssl_certificate_arn_public
  }

  listener {
    instance_port     = 5060
    instance_protocol = "tcp"
    lb_port           = 5060
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 5061
    instance_protocol = "tcp"
    lb_port           = 5061
    lb_protocol       = "tcp"
  }

  dynamic "listener" {
    for_each = var.initial_configuration ? [1] : []
    content {
      instance_port      = 8443
      instance_protocol  = "https"
      lb_port            = 8443
      lb_protocol        = "https"
      ssl_certificate_id = var.elb_ssl_certificate_arn_public
    }
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = var.initial_configuration ? "TCP:8443" : "TCP:443"
    interval            = 30
  }

  instances                   = [aws_instance.pexip_conference.id]
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.name}-conference-elb"
  }
}
