// Check if the EKS cluster exists
data "aws_eks_cluster" "existing_eks" {
  provider = aws.target
  name     = var.cluster_name
}

resource "aws_eks_cluster" "eks" {
  provider = aws.target
  count    = length(data.aws_eks_cluster.existing_eks.arns) == 0 ? 1 : 0
  name     = var.cluster_name
  role_arn = aws_eks_cluster.eks.role_arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = var.security_group_ids
    endpoint_private_access = var.create_private_endpoint
    endpoint_public_access  = !var.create_private_endpoint
  }

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

  depends_on = [aws_iam_role_policy_attachment.target_role_attachment]
}

// Create NLB
resource "aws_lb" "nlb" {
  provider           = aws.target
  count              = length(data.aws_lb.existing_nlb.arns) == 0 ? 1 : 0
  name               = var.nlb_name
  internal           = true
  load_balancer_type = "network"
  subnets            = var.subnet_ids
  security_groups    = var.security_group_ids

  depends_on = [aws_iam_role_policy_attachment.target_role_attachment]
}

// Create Listener for NLB
resource "aws_lb_listener" "nlb_listener" {
  provider          = aws.target
  load_balancer_arn = aws_lb.nlb[0].arn
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

// Create Endpoint Service
resource "aws_vpc_endpoint_service" "endpoint_service" {
  provider                   = aws.target
  acceptance_required        = true
  network_load_balancer_arns = [aws_lb.nlb[0].arn]
  allowed_principals         = var.allowed_principals

  depends_on = [aws_iam_role_policy_attachment.target_role_attachment]
}

output "endpoint_service_name" {
  description = "Endpoint Service Name"
  value       = aws_vpc_endpoint_service.endpoint_service.service_name
}