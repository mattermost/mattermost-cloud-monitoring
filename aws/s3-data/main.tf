# Create the S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}

# Block all public access to the bucket
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "my_bucket" {
  bucket = aws_s3_bucket.my_bucket.id
  policy = data.aws_iam_policy_document.my_bucket_policy.json
}

# Define the IAM policy for the S3 bucket
data "aws_iam_policy_document" "my_bucket_policy" {
  statement {
    effect = "Deny"
    actions = [
      "s3:HeadBucket",
      "s3:ListBucket*",
      "s3:GetObject*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [
      aws_s3_bucket.my_bucket.arn,
      "${aws_s3_bucket.my_bucket.arn}/*",
    ]

    condition {
      test     = "StringNotLike"
      variable = "aws:userId"

      values = flatten([[
        aws_iam_user.my_user.unique_id,
        "AROA*"
      ]])
    }
  }
}

# Create the IAM user
resource "aws_iam_user" "my_user" {
  name = var.iam_user_name
}

resource "aws_iam_policy" "my_user_policy" {
  name        = "${var.iam_user_name}-policy"
  path        = "/"
  description = "Permissions for bucket"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:HeadBucket",
                "s3:ListBucket*",
                "s3:GetObject*"
            ],
            "Resource": [
                "${aws_s3_bucket.my_bucket.arn}",
                "${aws_s3_bucket.my_bucket.arn}/*"
            ]
        }
    ]
}
EOF

}


# Attach the policy to the IAM user
resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.my_user.name
  policy_arn = aws_iam_policy.my_user_policy.arn
}
