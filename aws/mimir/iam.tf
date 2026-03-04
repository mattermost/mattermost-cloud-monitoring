################################################################################
# IAM Policy for Mimir Pods (IRSA)
#
# Grants Mimir pods access to S3 buckets and MSK Serverless cluster.
# Attach this policy to the Mimir ServiceAccount via IRSA.
################################################################################

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_policy" "mimir" {
  name        = "mimir-${var.environment}"
  description = "IAM policy for Mimir pods - S3 and MSK access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "MimirS3Access"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [
          aws_s3_bucket.mimir_blocks.arn,
          "${aws_s3_bucket.mimir_blocks.arn}/*",
          aws_s3_bucket.mimir_alertmanager.arn,
          "${aws_s3_bucket.mimir_alertmanager.arn}/*",
          aws_s3_bucket.mimir_ruler.arn,
          "${aws_s3_bucket.mimir_ruler.arn}/*"
        ]
      },
      {
        Sid    = "MimirMSKConnect"
        Effect = "Allow"
        Action = [
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeCluster"
        ]
        Resource = var.enable_msk ? [
          aws_msk_serverless_cluster.mimir_ingest[0].arn
        ] : []
      },
      {
        Sid    = "MimirMSKTopicAccess"
        Effect = "Allow"
        Action = [
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:CreateTopic",
          "kafka-cluster:WriteData",
          "kafka-cluster:ReadData"
        ]
        Resource = var.enable_msk ? [
          "arn:aws:kafka:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:topic/${aws_msk_serverless_cluster.mimir_ingest[0].cluster_name}/*"
        ] : []
      },
      {
        Sid    = "MimirMSKGroupAccess"
        Effect = "Allow"
        Action = [
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:AlterGroup"
        ]
        Resource = var.enable_msk ? [
          "arn:aws:kafka:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:group/${aws_msk_serverless_cluster.mimir_ingest[0].cluster_name}/*"
        ] : []
      }
    ]
  })

  tags = merge(var.tags, {
    Component = "mimir"
    ManagedBy = "terraform"
  })
}
