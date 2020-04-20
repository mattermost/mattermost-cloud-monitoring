resource "aws_lb" "pritunl_nlb" {
  name                             = "${var.name}-nlb"
  internal                         = false
  load_balancer_type               = "network"
  subnets                          = var.public_subnet_ids
  enable_cross_zone_load_balancing = false

  tags = merge(
    map("Name", "${var.name}-nlb"),
    local.default_tags
  )

}

# webui 443
resource "aws_lb_target_group" "pritunl_nlb_tg_webui" {
  name     = "tf-pritunl-tg-webui"
  port     = 443
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
    protocol            = "TCP"
  }

  tags = merge(
    map("Name", "${var.name}-tg-webui"),
    local.default_tags
  )
}

resource "aws_lb_listener" "pritunl_nlb_listener_webui" {
  load_balancer_arn = aws_lb.pritunl_nlb.arn
  port              = 443
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.pritunl_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pritunl_nlb_tg_webui.arn
  }
}

# vpn 1194
resource "aws_lb_target_group" "pritunl_nlb_tg_vpn" {
  name     = "tf-pritunl-tg-vpn"
  port     = 1194
  protocol = "UDP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
    protocol            = "TCP"
    port                = "443"
  }

  tags = merge(
    map("Name", "${var.name}-tg-vpn"),
    local.default_tags
  )
}

resource "aws_lb_listener" "pritunl_nlb_listener_vpn" {
  load_balancer_arn = aws_lb.pritunl_nlb.arn
  port              = 1194
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pritunl_nlb_tg_vpn.arn
  }
}

# vpn 1195
resource "aws_lb_target_group" "pritunl_nlb_tg_vpn_1" {
  name     = "tf-pritunl-tg-vpn-1"
  port     = 1195
  protocol = "UDP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
    protocol            = "TCP"
    port                = "443"
  }

  tags = merge(
    map("Name", "${var.name}-tg-vpn-1"),
    local.default_tags
  )
}

resource "aws_lb_listener" "pritunl_nlb_listener_vpn_1" {
  load_balancer_arn = aws_lb.pritunl_nlb.arn
  port              = 1195
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pritunl_nlb_tg_vpn_1.arn
  }
}

# vpn 1196
resource "aws_lb_target_group" "pritunl_nlb_tg_vpn_2" {
  name     = "tf-pritunl-tg-vpn-2"
  port     = 1196
  protocol = "UDP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
    protocol            = "TCP"
    port                = "443"
  }

  tags = merge(
    map("Name", "${var.name}-tg-vpn-2"),
    local.default_tags
  )
}

resource "aws_lb_listener" "pritunl_nlb_listener_vpn_2" {
  load_balancer_arn = aws_lb.pritunl_nlb.arn
  port              = 1196
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pritunl_nlb_tg_vpn_2.arn
  }
}

# http 80
resource "aws_lb_target_group" "pritunl_nlb_tg_http" {
  name     = "tf-pritunl-tg-http"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
    protocol            = "TCP"
  }

  tags = merge(
    map("Name", "${var.name}-tg-http"),
    local.default_tags
  )
}

resource "aws_lb_listener" "pritunl_nlb_listener_http" {
  load_balancer_arn = aws_lb.pritunl_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pritunl_nlb_tg_http.arn
  }
}
