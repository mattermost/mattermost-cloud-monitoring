#############» ArgoCD Deployer IAM Role###################
resource "aws_iam_role" "argocd-deployer" {
  name = "ArgoCD-Deployer"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "arn:aws:iam::631640027723:role/ArgoCD"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
