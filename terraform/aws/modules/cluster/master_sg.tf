###################» EKS Master Cluster Security Group#############

resource "aws_security_group" "cluster-sg" {
  name        = "${var.deployment_name}-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.deployment_name}-sg"
  }
}

resource "aws_security_group_rule" "master-teleport" {
  cidr_blocks       = var.teleport_cidr
  description       = "Allow teleport access to master"
  from_port         = 3022
  protocol          = "tcp"
  security_group_id = aws_security_group.cluster-sg.id
  to_port           = 3022
  type              = "ingress"
}

resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  cidr_blocks       = var.cidr_blocks
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.cluster-sg.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "prometheus-lambda-ingress" {
  description              = "Allow prometheus lambda registration service to communicate with cluster"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster-sg.id
  source_security_group_id = aws_security_group.lambda-sg.id
  to_port                  = 443
  type                     = "ingress"
}
