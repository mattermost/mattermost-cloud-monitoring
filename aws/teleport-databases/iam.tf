resource "aws_iam_role" "TeleportDBAccessRole" {
  name = "TeleportDBAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com" # Adjust to the service you are using
        }
      }
    ]
  })
}

resource "aws_iam_policy" "teleport_main_teleport_database_access" {
  name        = "teleport-main-teleport-database-access"
  description = "Main policy for Teleport database access"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = []
  })
}

resource "aws_iam_policy" "TeleportDBAccessAndDiscoveryPolicy" {
  name        = "TeleportDBAccessAndDiscoveryPolicy"
  description = "Policy to allow RDS connection and metadata discovery for Teleport"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "RDSConnect",
        Effect   = "Allow",
        Action   = "rds-db:connect",
        Resource = "*"
      },
      {
        Sid    = "RDSFetchMetadataClusters",
        Effect = "Allow",
        Action = [
          "rds:DescribeDBClusters"
        ],
        Resource = "*",
        Condition = {
          "ForAllValues:StringEquals" = {
            "rds:cluster-tag/teleport-enabled" = [
              "true"
            ]
          }
        }
      },
      {
        Sid    = "RDSFetchMetadataInstances",
        Effect = "Allow",
        Action = [
          "rds:DescribeDBInstances"
        ],
        Resource = "*",
        Condition = {
          "ForAllValues:StringEquals" = {
            "rds:db-tag/teleport-enabled" = [
              "true"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_main_policy" {
  role       = aws_iam_role.TeleportDBAccessRole.name
  policy_arn = aws_iam_policy.teleport_main_teleport_database_access.arn
}

resource "aws_iam_role_policy_attachment" "attach_discovery_policy" {
  role       = aws_iam_role.TeleportDBAccessRole.name
  policy_arn = aws_iam_policy.TeleportDBAccessAndDiscoveryPolicy.arn
}
