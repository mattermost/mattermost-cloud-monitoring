resource "aws_shield_protection" "protected-resource" {
  for_each     = var.protected_resources
  name         = each.key
  resource_arn = each.value
}

resource "aws_iam_role" "drt-waf-access" {
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "drt.shield.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "waf-logs" {
  bucket            = "mattermost-${var.environment}-waf-logs"
}

resource "aws_s3_bucket_acl" "waf-lgos" {
  bucket = aws_s3_bucket.waf-logs.id
  acl    = "private"
}

resource "aws_iam_role_policy" "drt-mattermost-waf-logs-s3-access" {
  name   = "drt-mattermost-waf-logs-s3-access"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:GetLifecycleConfiguration",
                "s3:GetBucketTagging",
                "s3:GetInventoryConfiguration",
                "s3:GetObjectVersionTagging",
                "s3:ListBucketVersions",
                "s3:GetBucketLogging",
                "s3:ListBucket",
                "s3:GetAccelerateConfiguration",
                "s3:GetBucketPolicy",
                "s3:GetStorageLensConfigurationTagging",
                "s3:GetObjectVersionTorrent",
                "s3:GetObjectAcl",
                "s3:GetEncryptionConfiguration",
                "s3:GetBucketObjectLockConfiguration",
                "s3:GetBucketRequestPayment",
                "s3:GetAccessPointPolicyStatus",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectTagging",
                "s3:GetMetricsConfiguration",
                "s3:GetBucketOwnershipControls",
                "s3:GetBucketPublicAccessBlock",
                "s3:GetBucketPolicyStatus",
                "s3:ListBucketMultipartUploads",
                "s3:GetObjectRetention",
                "s3:GetBucketWebsite",
                "s3:GetJobTagging",
                "s3:GetBucketVersioning",
                "s3:GetBucketAcl",
                "s3:GetObjectLegalHold",
                "s3:GetBucketNotification",
                "s3:GetReplicationConfiguration",
                "s3:ListMultipartUploadParts",
                "s3:GetObject",
                "s3:GetStorageLensConfiguration",
                "s3:GetObjectTorrent",
                "s3:DescribeJob",
                "s3:GetBucketCORS",
                "s3:GetAnalyticsConfiguration",
                "s3:GetObjectVersionForReplication",
                "s3:GetBucketLocation",
                "s3:GetAccessPointPolicy",
                "s3:GetObjectVersion",
                "s3:GetStorageLensDashboard"
            ],
            "Resource": "arn:aws:s3:::${aws_s3_bucket.waf-logs.bucket}"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:ListStorageLensConfigurations",
                "s3:GetAccessPoint",
                "s3:GetAccountPublicAccessBlock",
                "s3:ListAllMyBuckets",
                "s3:ListAccessPoints",
                "s3:ListJobs"
            ],
            "Resource": "*"
        }
    ]
}
EOF
  role   = aws_iam_role.drt-waf-access.id
}

resource "aws_iam_role_policy_attachment" "drt-waf-access" {
  role       = aws_iam_role.drt-waf-access.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSShieldDRTAccessPolicy"
}
