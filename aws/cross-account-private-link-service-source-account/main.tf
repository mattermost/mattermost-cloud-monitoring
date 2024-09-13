// Create EC2 instance in the source account
resource "aws_instance" "service" {
  provider               = aws.source
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  depends_on = [aws_iam_role_policy_attachment.source_role_attachment]

  tags = var.instance_tags
}

// Attempt to read the NLB if the check is enabled
data "aws_lb" "existing_nlb" {
  provider = aws.source
  name     = var.nlb_name

  # This will fail gracefully if the condition is not met
  count = var.check_nlb ? 1 : 0
}

// Use a local value to determine if the NLB exists without causing an error
locals {
  nlb_exists = length(data.aws_lb.existing_nlb) > 0
}

// Create NLB in the source account only if it doesn't exist
resource "aws_lb" "nlb" {
  provider           = aws.source
  count              = local.nlb_exists ? 0 : 1
  name               = var.nlb_name
  internal           = true
  load_balancer_type = "network"
  subnets            = [var.subnet_id] // Ensure subnets are in distinct Availability Zones
  security_groups    = [var.security_group_id]

  depends_on = [aws_iam_role_policy_attachment.source_role_attachment]
}

// Determine NLB ARN to use
locals {
  nlb_arn = local.nlb_exists ? data.aws_lb.existing_nlb[0].arn : aws_lb.nlb[0].arn
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

// Automatically register the EC2 instance (service) to the NLB target group
resource "aws_lb_target_group_attachment" "service_attachment" {
  provider         = aws.source
  count            = local.nlb_exists ? 0 : 1
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.service.id // Fixed by removing the index
  port             = var.listener_port       // Port on which the service instance should be registered

  depends_on = [aws_instance.service]
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
