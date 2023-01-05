resource "aws_iam_role" "provisioner_role" {
  name = "k8s-${var.environment}-provisioner_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
       "Principal": {
        "AWS": [ "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.deployment_name}-worker-role" ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "provisioner_role_attach_route53" {
  role       = aws_iam_role.provisioner_role.name
  policy_arn = aws_iam_policy.route53.arn
}

resource "aws_iam_role_policy_attachment" "provisioner_role_attach_rds" {
  role       = aws_iam_role.provisioner_role.name
  policy_arn = aws_iam_policy.rds.arn
}

resource "aws_iam_role_policy_attachment" "provisioner_role_attach_s3" {
  role       = aws_iam_role.provisioner_role.name
  policy_arn = aws_iam_policy.s3.arn
}

resource "aws_iam_role_policy_attachment" "provisioner_role_attach_secrets_manager" {
  role       = aws_iam_role.provisioner_role.name
  policy_arn = aws_iam_policy.secrets_manager.arn
}

resource "aws_iam_role_policy_attachment" "provisioner_role_attach_ec2" {
  role       = aws_iam_role.provisioner_role.name
  policy_arn = aws_iam_policy.ec2.arn
}

resource "aws_iam_role_policy_attachment" "provisioner_role_attach_iam" {
  role       = aws_iam_role.provisioner_role.name
  policy_arn = aws_iam_policy.iam.arn
}

resource "aws_iam_role_policy_attachment" "provisioner_role_attach_kms" {
  role       = aws_iam_role.provisioner_role.name
  policy_arn = aws_iam_policy.kms.arn
}

resource "aws_iam_role_policy_attachment" "provisioner_role_attach_tag" {
  role       = aws_iam_role.provisioner_role.name
  policy_arn = aws_iam_policy.tag.arn
}
