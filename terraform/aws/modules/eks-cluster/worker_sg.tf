##########» Worker Node Security Group###########
resource "aws_security_group" "worker-sg" {
  name        = "${var.deployment_name}-worker-sg"
  description = "Security group for all workers in the cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = map(
     "Name", "${var.deployment_name}-worker-sg",
     "kubernetes.io/cluster/${var.deployment_name}", "owned",
    )
}

resource "aws_security_group_rule" "worker-sg-ingress-self" {
  description              = "Allow workers to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.worker-sg.id
  source_security_group_id = aws_security_group.worker-sg.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "worker-sg-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker-sg.id
  source_security_group_id = aws_security_group.cluster-sg.id
  to_port                  = 65535
  type                     = "ingress"
}
