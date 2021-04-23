resource "aws_iam_user" "awat_user" {
  name = "mattermost-awat-${var.environment}"
  path = "/"
}

resource "aws_iam_policy" "s3" {
  name        = "mattermost-awat-route53-policy${local.conditional_dash_region}"
  path        = "/"
  description = "Route53 permissions for awat user"

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

resource "aws_iam_user_policy_attachment" "attach_s3" {
  user       = aws_iam_user.awat_user.name
  policy_arn = aws_iam_policy.s3.arn
}
