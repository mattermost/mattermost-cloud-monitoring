#############» ArgoCD Deployer IAM Role###################
resource "aws_iam_role" "argocd-deployer" {
  count = var.argocd_account_role == "" ? 0 : 1

  name = "ArgoCD-Deployer"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.argocd_account_role}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
