resource "aws_route53_record" "calls_offloader" {
  zone_id = var.private_hosted_zoneid
  name    = "calls-offloader"
  type    = "A"

  alias {
    name                   = aws_lb.calls_offloader.dns_name
    zone_id                = aws_lb.calls_offloader.zone_id
    evaluate_target_health = true
  }
}


resource "aws_lb" "calls_offloader" {
  name               = "calls-offloader-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = [var.subnet_id]

  tags = {
    Name        = "Call Offloader LB"
    Created     = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
  }
}

# webui 443
resource "aws_lb_target_group" "calls_offloader" {
  name     = "calls-offloader"
  port     = 4545
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
    protocol            = "TCP"
  }

  tags = {
    Name        = "Call Offloader TG"
    Created     = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
  }
}


resource "aws_lb_listener" "calls_offloader" {
  load_balancer_arn = aws_lb.calls_offloader.arn
  port              = "4545"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.calls_offloader.arn
  }

  tags = {
    Name        = "Call Offloader Listener"
    Created     = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.calls_offloader.id
  lb_target_group_arn    = aws_lb_target_group.calls_offloader.arn
}
