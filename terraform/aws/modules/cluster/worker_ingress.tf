############Worker Node Access to EKS Master Cluste#############

resource "aws_security_group_rule" "worker-ingress" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.cluster-sg.id}"
  source_security_group_id = "${aws_security_group.worker-sg.id}"
  to_port                  = 443
  type                     = "ingress"
}