resource "aws_iam_policy" "policy" {
  name        = var.customer_policy_name
  path        = "/"
  description = "Permissions for customer workspace migration"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "kms:Decrypt",
                "kms:GenerateDataKey"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket}/${var.customer_bucket_folder}/*",
                "arn:aws:kms:${var.region}:${var.account_id}:key/${var.kms_key}"
            ]
        }
    ]
}
EOF

}

resource "aws_iam_user" "user" {
  name = "cloud-data-import-${var.customer_bucket_folder}"
}

resource "aws_iam_user_policy_attachment" "attachment" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_s3_bucket_object" "customer_folder" {
  bucket       = var.bucket
  acl          = "private"
  key          = "${var.customer_bucket_folder}/"
  content_type = "application/x-directory"
  kms_key_id   = "arn:aws:kms:${var.region}:${var.account_id}:key/${var.kms_key}"
}
