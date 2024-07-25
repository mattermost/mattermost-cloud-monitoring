resource "aws_lb" "eks_nlb" {
  name               = "eks-nlb"
  internal           = true
  load_balancer_type = "network"

  subnet_mappings {
    subnet_id = var.subnet_id
  }
}

resource "aws_lb_target_group" "eks_tg" {
  name     = "eks-tg"
  port     = 443
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "eks_listener" {
  load_balancer_arn = aws_lb.eks_nlb.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_tg.arn
  }
}

resource "aws_vpc_endpoint_service" "eks_vpce_service" {
  acceptance_required        = true
  network_load_balancer_arns = [aws_lb.eks_nlb.arn]
}
