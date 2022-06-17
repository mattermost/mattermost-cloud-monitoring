resource "aws_lb" "pritunl_nlb" {
  name                             = "${var.name}-nlb"
  internal                         = false
  load_balancer_type               = "network"
  subnets                          = var.public_subnet_ids
  enable_cross_zone_load_balancing = false

  tags = merge(
    tomap({ "Name" = "${var.name}-nlb" }),
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
    tomap({ "Name" = "${var.name}-tg-webui" }),
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

# vpn 1191
resource "aws_lb_target_group" "pritunl_nlb_tg_vpn_6" {
  name     = "tf-pritunl-tg-vpn-6"
  port     = 1191
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
    tomap({ "Name" = "${var.name}-tg-vpn-6" }),
    local.default_tags
  )
}

resource "aws_lb_listener" "pritunl_nlb_listener_vpn_6" {
  load_balancer_arn = aws_lb.pritunl_nlb.arn
  port              = 1191
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pritunl_nlb_tg_vpn_6.arn
  }
}
# vpn 1192
resource "aws_lb_target_group" "pritunl_nlb_tg_vpn_7" {
  name     = "tf-pritunl-tg-vpn-7"
  port     = 1192
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
    tomap({ "Name" = "${var.name}-tg-vpn-7" }),
    local.default_tags
  )
}

resource "aws_lb_listener" "pritunl_nlb_listener_vpn_7" {
  load_balancer_arn = aws_lb.pritunl_nlb.arn
  port              = 1192
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pritunl_nlb_tg_vpn_7.arn
  }
}
# vpn 1193
resource "aws_lb_target_group" "pritunl_nlb_tg_vpn_8" {
  name     = "tf-pritunl-tg-vpn-8"
  port     = 1193
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
    tomap({ "Name" = "${var.name}-tg-vpn-8" }),
    local.default_tags
  )
}

resource "aws_lb_listener" "pritunl_nlb_listener_vpn_8" {
  load_balancer_arn = aws_lb.pritunl_nlb.arn
  port              = 1193
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pritunl_nlb_tg_vpn_8.arn
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
    tomap({ "Name" = "${var.name}-tg-vpn" }),
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
    tomap({ "Name" = "${var.name}-tg-vpn-1" }),
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
    tomap({ "Name" = "${var.name}-tg-vpn-2" }),
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

# vpn 1197
resource "aws_lb_target_group" "pritunl_nlb_tg_vpn_3" {
  name     = "tf-pritunl-tg-vpn-3"
  port     = 1197
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
    tomap({ "Name" = "${var.name}-tg-vpn-3" }),
    local.default_tags
  )
}

resource "aws_lb_listener" "pritunl_nlb_listener_vpn_3" {
  load_balancer_arn = aws_lb.pritunl_nlb.arn
  port              = 1197
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pritunl_nlb_tg_vpn_3.arn
  }
}
# vpn 1198
resource "aws_lb_target_group" "pritunl_nlb_tg_vpn_4" {
  name     = "tf-pritunl-tg-vpn-4"
  port     = 1198
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
    tomap({ "Name" = "${var.name}-tg-vpn-4" }),
    local.default_tags
  )
}

resource "aws_lb_listener" "pritunl_nlb_listener_vpn_4" {
  load_balancer_arn = aws_lb.pritunl_nlb.arn
  port              = 1198
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pritunl_nlb_tg_vpn_4.arn
  }
}
# vpn 1199
resource "aws_lb_target_group" "pritunl_nlb_tg_vpn_5" {
  name     = "tf-pritunl-tg-vpn-5"
  port     = 1199
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
    tomap({ "Name" = "${var.name}-tg--5" }),
    local.default_tags
  )
}

resource "aws_lb_listener" "pritunl_nlb_listener_vpn_5" {
  load_balancer_arn = aws_lb.pritunl_nlb.arn
  port              = 1199
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pritunl_nlb_tg_vpn_5.arn
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
    tomap({ "Name" = "${var.name}-tg-http" }),
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
