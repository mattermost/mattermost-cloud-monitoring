resource "aws_iam_policy" "community-provisioning-policy" {
  name        = "community-policy"
  path        = "/"
  description = "S3 & Volume permissions for community role"

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
resource "aws_iam_user" "community-provisioning-user" {
  name          = "${var.deployment_name}-${var.vpc_id}"
  path          = "/"
}

# Create the access key
resource "aws_iam_access_key" "community-provisioning-key" {
  user = aws_iam_user.community-provisioning-user.name
}

resource "aws_iam_user_policy_attachment" "community-provisioning-policy-attach" {
  user       = aws_iam_user.community-provisioning-user.name
  policy_arn = aws_iam_policy.community-provisioning-policy.arn
}

output "encrypted_secret" {
  value = aws_iam_access_key.community-provisioning-key.encrypted_secret
}
output "id" {
  value = aws_iam_access_key.community-provisioning-key.id
}
output "secret" {
  value = aws_iam_access_key.community-provisioning-key.secret
}

