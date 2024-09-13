// Attempt to read the EKS cluster if check is enabled
data "aws_eks_cluster" "existing_eks" {
  provider = aws.target
  name     = var.cluster_name

  # This will fail gracefully if the condition is not met
  count = var.check_eks ? 1 : 0
}

// Local value to determine if the EKS cluster exists
locals {
  eks_cluster_exists = length(data.aws_eks_cluster.existing_eks) > 0
}

// Create the EKS cluster only if it doesn't exist
resource "aws_eks_cluster" "eks" {
  provider = aws.target
  count    = local.eks_cluster_exists ? 0 : 1
  name     = var.cluster_name
  role_arn = aws_iam_role.target_role.arn // Ensure this role is defined or correct as per your setup

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = var.security_group_ids
    endpoint_private_access = var.create_private_endpoint
    endpoint_public_access  = !var.create_private_endpoint
  }

  tags = var.eks_cluster_tags

  depends_on = [aws_iam_role_policy_attachment.target_role_attachment]
}

// Conditionally create a proxy instance if EKS is private
resource "aws_instance" "proxy" {
  provider               = aws.target
  count                  = var.create_private_endpoint ? 1 : 0
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.proxy_subnet_id
  vpc_security_group_ids = var.proxy_security_group_ids
  key_name               = var.key_name

  depends_on = [aws_iam_role_policy_attachment.target_role_attachment]

  tags = var.proxy_tags
}

// Attempt to read the NLB if check is enabled
data "aws_lb" "existing_nlb" {
  provider = aws.target
  name     = var.nlb_name

  # This will fail gracefully if the condition is not met
  count = var.check_nlb ? 1 : 0
}

// Local value to determine if the NLB exists
locals {
  nlb_exists = length(data.aws_lb.existing_nlb) > 0
}

// Create NLB if it doesn't exist
resource "aws_lb" "nlb" {
  provider           = aws.target
  count              = local.nlb_exists ? 0 : 1
  name               = var.nlb_name
  internal           = true
  load_balancer_type = "network"
  subnets            = var.subnet_ids
  security_groups    = var.security_group_ids

  depends_on = [aws_iam_role_policy_attachment.target_role_attachment]
}

// Determine NLB ARN to use
locals {
  nlb_arn = local.nlb_exists ? data.aws_lb.existing_nlb[0].arn : aws_lb.nlb[0].arn
}

// Create Listener for NLB, referencing either existing or newly created NLB
resource "aws_lb_listener" "nlb_listener" {
  provider          = aws.target
  load_balancer_arn = local.nlb_arn
  port              = var.listener_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  depends_on = [aws_iam_role_policy_attachment.target_role_attachment]
}

// Create Target Group
resource "aws_lb_target_group" "target_group" {
  provider = aws.target
  name     = var.target_group_name
  port     = var.listener_port
  protocol = "TCP"
  vpc_id   = var.vpc_id

  depends_on = [aws_iam_role_policy_attachment.target_role_attachment]
}

// Register Proxy Instance to the NLB Target Group
resource "aws_lb_target_group_attachment" "proxy_attachment" {
  provider         = aws.target
  count            = var.create_private_endpoint ? 1 : 0
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.proxy[0].id
  port             = var.listener_port // Port on which the proxy instance should be registered

  depends_on = [aws_instance.proxy]
}

// Create Endpoint Service
resource "aws_vpc_endpoint_service" "endpoint_service" {
  provider                   = aws.target
  acceptance_required        = true
  network_load_balancer_arns = [local.nlb_arn]
  allowed_principals         = var.allowed_principals

  depends_on = [aws_iam_role_policy_attachment.target_role_attachment]
}

output "endpoint_service_name" {
  description = "Endpoint Service Name"
  value       = aws_vpc_endpoint_service.endpoint_service.service_name
}
