resource "aws_iam_user" "pipelinewise_user" {
  name = "mattermost-pipelinewise-${var.environment}"
  path = "/"
}

resource "aws_iam_policy" "pipelinewise-policy" {
  name        = "pipelinewise-policy"
  path        = "/"
  description = "Permissions for pipelinewise bucket"

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
                "arn:aws:s3:::${aws_s3_bucket.pipelinewise.bucket_domain_name}/${var.snowflake_imports}/*",
                "arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/${var.kms_key}"
            ]
        }
    ]
}
EOF

}

resource "aws_iam_user_policy_attachment" "attachment" {
  user       = aws_iam_user.pipelinewise_user.name
  policy_arn = aws_iam_policy.pipelinewise-policy.arn
}

resource "aws_s3_bucket_object" "snowflake_imports" {
  bucket                 = aws_s3_bucket.pipelinewise.id
  acl                    = "private"
  key                    = "${var.snowflake_imports}/"
  content_type           = "application/x-directory"
  kms_key_id             = "arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/${var.kms_key}"
  server_side_encryption = "aws:kms"
}
