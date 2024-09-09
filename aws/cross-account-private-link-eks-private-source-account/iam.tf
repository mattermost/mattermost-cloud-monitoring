resource "aws_iam_role" "source_role" {
  name = "SourceAccountTerraformRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "source_policy" {
  name        = "SourceAccountTerraformPolicy"
  description = "IAM policy for managing VPC Endpoints in the source account"

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

resource "aws_iam_role_policy_attachment" "source_role_attachment" {
  role       = aws_iam_role.source_role.name
  policy_arn = aws_iam_policy.source_policy.arn
}
