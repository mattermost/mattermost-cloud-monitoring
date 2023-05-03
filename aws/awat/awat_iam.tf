resource "aws_iam_role" "awat-role" {
  name               = "k8s-${var.environment}-awat"
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

resource "aws_iam_policy" "awat-policy" {
  name        = "mattermost-awat-route53-policy${local.conditional_dash_region}"
  path        = "/"
  description = "Route53 permissions for awat role"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
         {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets"
            ],
            "Resource": "arn:aws:s3:::*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation",
                "s3:GetBucketTagging"
            ],
            "Resource": [
                "arn:aws:s3:::cloud-awat-${var.environment}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:DeleteObject",
                "s3:GetObjectVersionAcl"
            ],
            "Resource": [
                "arn:aws:s3:::cloud-awat-${var.environment}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "awat-policy-attach" {
  role       = aws_iam_role.awat-role.name
  policy_arn = aws_iam_policy.awat-policy.arn
}
