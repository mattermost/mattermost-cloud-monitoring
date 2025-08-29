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
  for_each = var.conference_nodes

  name            = "${var.name}-conference-elb-${each.key}"
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

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 10
    target              = var.initial_configuration ? "TCP:8443" : "TCP:443"
    interval            = 60
  }

  instances                   = [aws_instance.pexip_conference[each.key].id]
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.name}-conference-elb-${each.key}"
  }
}

# SSL Negotiation Policy for Management ELB
resource "aws_load_balancer_policy" "pexip_management_ssl_policy" {
  load_balancer_name = aws_elb.pexip_management_elb.name
  policy_name        = "${var.name}-management-ssl-policy"
  policy_type_name   = "SSLNegotiationPolicyType"

  policy_attribute {
    name  = "Reference-Security-Policy"
    value = "ELBSecurityPolicy-TLS-1-2-2017-01"
  }
}

resource "aws_load_balancer_listener_policy" "pexip_management_listener_policy" {
  load_balancer_name = aws_elb.pexip_management_elb.name
  load_balancer_port = 443

  policy_names = [
    aws_load_balancer_policy.pexip_management_ssl_policy.policy_name,
  ]
}

# SSL Negotiation Policy for Conference ELBs
# Note: Each ELB requires its own policy resource, even with identical configuration,
# because policies are scoped to a specific load balancer via the load_balancer_name parameter
resource "aws_load_balancer_policy" "pexip_conference_ssl_policy" {
  for_each = var.conference_nodes

  load_balancer_name = aws_elb.pexip_conference_elb[each.key].name
  policy_name        = "${var.name}-conference-ssl-policy-${each.key}"
  policy_type_name   = "SSLNegotiationPolicyType"

  policy_attribute {
    name  = "Reference-Security-Policy"
    value = "ELBSecurityPolicy-TLS-1-2-2017-01"
  }
}

resource "aws_load_balancer_listener_policy" "pexip_conference_listener_policy_443" {
  for_each = var.conference_nodes

  load_balancer_name = aws_elb.pexip_conference_elb[each.key].name
  load_balancer_port = 443

  policy_names = [
    aws_load_balancer_policy.pexip_conference_ssl_policy[each.key].policy_name,
  ]
}

# SSL Negotiation Policy for Conference ELBs port 8443 (only when initial_configuration is true)
resource "aws_load_balancer_listener_policy" "pexip_conference_listener_policy_8443" {
  for_each = var.initial_configuration ? var.conference_nodes : {}

  load_balancer_name = aws_elb.pexip_conference_elb[each.key].name
  load_balancer_port = 8443

  policy_names = [
    aws_load_balancer_policy.pexip_conference_ssl_policy[each.key].policy_name,
  ]
}
