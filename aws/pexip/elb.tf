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
    ssl_certificate_id = var.elb_ssl_certificate_arn
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
