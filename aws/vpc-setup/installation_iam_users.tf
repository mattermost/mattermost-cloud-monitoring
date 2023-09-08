resource "aws_iam_user" "installation_users" {
  for_each = toset(var.vpc_cidrs)

  name = format("%s-%s", var.name, aws_vpc.vpc_creation[each.value]["id"])
  path = "/"

  tags = merge(
    {
      "Name"      = format("%s-%s", var.name, aws_vpc.vpc_creation[each.value]["id"]),
      "VpcID"     = aws_vpc.vpc_creation[each.value]["id"],
      "Filestore" = "Multitenant"
    },
    var.tags
  )

}

resource "aws_iam_access_key" "installation_users" {
  for_each = toset(var.vpc_cidrs)

  user = aws_iam_user.installation_users[each.value]["name"]
}

resource "aws_secretsmanager_secret" "installation_users_keys" {
  for_each = toset(var.vpc_cidrs)

  tags = merge(
    {
      "Name"      = format("%s-%s", var.name, aws_vpc.vpc_creation[each.value]["id"]),
      "VpcID"     = aws_vpc.vpc_creation[each.value]["id"],
      "Filestore" = "Multitenant"
    },
    var.tags
  )

  name = format("%s-%s", var.name, aws_vpc.vpc_creation[each.value]["id"])
}

resource "aws_secretsmanager_secret_version" "installation_users_keys" {
  for_each = toset(var.vpc_cidrs)

  secret_id = aws_secretsmanager_secret.installation_users_keys[each.value]["id"]
  secret_string = jsonencode({
    "ID"     = aws_iam_access_key.installation_users[each.value]["id"]
    "Secret" = aws_iam_access_key.installation_users[each.value]["secret"]
  })
}

resource "aws_iam_policy" "installation_users_s3_policy" {
  for_each = toset(var.vpc_cidrs)

  name        = format("%s-%s", var.name, aws_vpc.vpc_creation[each.value]["id"])
  path        = "/"
  description = "S3 permissions for installation user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "${aws_s3_bucket.installation_buckets[each.value]["arn"]}"
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
            "Resource": "${aws_s3_bucket.installation_buckets[each.value]["arn"]}/*"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "installation_users_attach_s3" {
  for_each = toset(var.vpc_cidrs)

  user       = aws_iam_user.installation_users[each.value]["name"]
  policy_arn = aws_iam_policy.installation_users_s3_policy[each.value]["arn"]
}

resource "aws_iam_policy" "installation_users_byok_s3_policy" {
  for_each = var.custom_vpc_kms_keys

  name        = format("%s-%s-byok", var.name, aws_vpc.vpc_creation[each.key]["id"])
  path        = "/"
  description = "S3 permissions for installation user with byok"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.installation_buckets[each.key]["arn"]}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-server-side-encryption": "aws:kms"
                }
            }
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:PutEncryptionConfiguration",
                "s3:GetObjectVersionTorrent",
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectTorrent",
                "s3:GetObjectRetention",
                "s3:PutObjectRetention",
                "kms:*",
                "s3:ListBucket",
                "s3:PutObjectLegalHold",
                "s3:GetObjectLegalHold",
                "s3:GetObjectVersionAttributes"
            ],
            "Resource": [
                "${aws_s3_bucket.installation_buckets[each.key]["arn"]}/*",
                "${var.custom_vpc_kms_keys[each.key]}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "installation_users_attach_s3_byok" {
  for_each = var.custom_vpc_kms_keys

  user       = aws_iam_user.installation_users[each.key]["name"]
  policy_arn = aws_iam_policy.installation_users_byok_s3_policy[each.key]["arn"]
}
