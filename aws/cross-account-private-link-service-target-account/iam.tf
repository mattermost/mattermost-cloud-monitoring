resource "aws_iam_role" "target_role" {
  name = "TargetAccountTerraformRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com" // Retains the existing principal
        }
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/atlantis-${var.environment}"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "target_policy" {
  name        = "TargetAccountTerraformPolicy"
  description = "IAM policy for managing VPC Endpoints in the target account"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateVpcEndpoint",
          "ec2:DescribeVpcEndpoints",
          "ec2:ModifyVpcEndpoint",
          "ec2:DeleteVpcEndpoints",
          "ec2:DescribeVpcEndpointServices"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "target_role_attachment" {
  role       = aws_iam_role.target_role.name
  policy_arn = aws_iam_policy.target_policy.arn
}
