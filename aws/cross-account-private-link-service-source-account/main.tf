// Create EC2 instance in the source account
resource "aws_instance" "service" {
  provider               = aws.source
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  depends_on = [aws_iam_role_policy_attachment.source_role_attachment]
}

// Check if NLB exists in the source account
data "aws_lb" "existing_nlb" {
  provider = aws.source
  name     = var.nlb_name
}

// Create NLB in the source account only if it doesn't exist
resource "aws_lb" "nlb" {
  provider           = aws.source
  count              = length([for lb in data.aws_lb.existing_nlb : lb.arn]) == 0 ? 1 : 0
  name               = var.nlb_name
  internal           = true
  load_balancer_type = "network"
  subnets            = [var.subnet_id]
  security_groups    = [var.security_group_id]

  depends_on = [aws_iam_role_policy_attachment.source_role_attachment]
}

// Determine NLB ARN to use
locals {
  nlb_arn = length([for lb in data.aws_lb.existing_nlb : lb.arn]) > 0 ? data.aws_lb.existing_nlb.arn : aws_lb.nlb[0].arn
}

// Create Listener for NLB in the source account
resource "aws_lb_listener" "nlb_listener" {
  provider          = aws.source
  load_balancer_arn = local.nlb_arn
  port              = var.listener_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  depends_on = [aws_iam_role_policy_attachment.source_role_attachment]
}

// Create Target Group in the source account
resource "aws_lb_target_group" "target_group" {
  provider = aws.source
  name     = var.target_group_name
  port     = var.listener_port
  protocol = "TCP"
  vpc_id   = var.vpc_id

  depends_on = [aws_iam_role_policy_attachment.source_role_attachment]
}

// Create Endpoint Service in the source account
resource "aws_vpc_endpoint_service" "endpoint_service" {
  provider                   = aws.source
  acceptance_required        = true
  network_load_balancer_arns = [local.nlb_arn]
  allowed_principals         = var.allowed_principals

  depends_on = [aws_iam_role_policy_attachment.source_role_attachment]
}

output "endpoint_service_name" {
  description = "Endpoint Service Name"
  value       = aws_vpc_endpoint_service.endpoint_service.service_name
}
