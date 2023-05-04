resource "aws_iam_role" "provisioner-role" {
  name               = "k8s-${var.environment}-provisioner"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Federated": "${var.open_oidc_provider_arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${var.open_oidc_provider_url}:sub": "system:serviceaccount:${var.namespace}:${var.serviceaccount}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "provisioner_role_attach_route53" {
  role       = aws_iam_role.provisioner-role.name
  policy_arn = aws_iam_policy.route53.arn
}

resource "aws_iam_role_policy_attachment" "provisioner_role_attach_rds" {
  role       = aws_iam_role.provisioner-role.name
  policy_arn = aws_iam_policy.rds.arn
}

resource "aws_iam_role_policy_attachment" "provisioner_role_attach_s3" {
  role       = aws_iam_role.provisioner-role.name
  policy_arn = aws_iam_policy.s3.arn
}

resource "aws_iam_role_policy_attachment" "provisioner_role_attach_secrets_manager" {
  role       = aws_iam_role.provisioner-role.name
  policy_arn = aws_iam_policy.secrets_manager.arn
}

resource "aws_iam_role_policy_attachment" "provisioner_role_attach_ec2" {
  role       = aws_iam_role.provisioner-role.name
  policy_arn = aws_iam_policy.ec2.arn
}

resource "aws_iam_role_policy_attachment" "provisioner_role_attach_vpc" {
  role       = aws_iam_role.provisioner-role.name
  policy_arn = aws_iam_policy.vpc.arn
}

resource "aws_iam_role_policy_attachment" "provisioner_role_attach_iam" {
  role       = aws_iam_role.provisioner-role.name
  policy_arn = aws_iam_policy.iam.arn
}

resource "aws_iam_role_policy_attachment" "provisioner_role_attach_kms" {
  role       = aws_iam_role.provisioner-role.name
  policy_arn = aws_iam_policy.kms.arn
}

resource "aws_iam_role_policy_attachment" "provisioner_role_attach_tag" {
  role       = aws_iam_role.provisioner-role.name
  policy_arn = aws_iam_policy.tag.arn
}
