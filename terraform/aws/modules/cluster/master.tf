################» EKS Master Cluster########################


resource "aws_eks_cluster" "cluster" {
  name            = "${var.deployment_name}"
  role_arn        = "${aws_iam_role.cluster-role.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.cluster-sg.id}"]
    subnet_ids         = ["${var.subnet_ids}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy",
  ]
}