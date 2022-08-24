resource "aws_iam_policy" "community-on-demand-policy" {
  name        = "community-ondemand-policy"
  path        = "/"
  description = "S3 & Volume permissions for on demand community role"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::${var.deployment_name}-${var.vpc_id}"
        },
        {
            "Sid": "AllObjectActions",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket",
                "s3:PutObjectAcl",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::${var.deployment_name}-${var.vpc_id}/*"
        }
    ]
}
EOF
}
resource "aws_iam_user" "community-on-demand-user" {
  name = "${var.deployment_name}-${var.vpc_id}"
  path = "/"
}

# Create the access key
resource "aws_iam_access_key" "community-on-demand-key" {
  user = aws_iam_user.community-on-demand-user.name
}

resource "aws_iam_user_policy_attachment" "community-on-demand-policy-attach" {
  user       = aws_iam_user.community-on-demand-user.name
  policy_arn = aws_iam_policy.community-on-demand-policy.arn
}

output "id" {
  value = aws_iam_access_key.community-on-demand-key.id
}
output "secret" {
  value = aws_iam_access_key.community-on-demand-key.secret
}
