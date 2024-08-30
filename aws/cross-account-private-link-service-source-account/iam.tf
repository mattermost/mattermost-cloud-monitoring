resource "aws_iam_role" "source_role" {
  name = "SourceAccountTerraformRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com" // Or use the appropriate principal
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "source_policy" {
  name        = "SourceAccountTerraformPolicy"
  description = "IAM policy for managing EC2, NLB, and Endpoint Service in the source account"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:RunInstances",
          "ec2:DescribeInstances",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeTargetGroups",
          "ec2:CreateVpcEndpointServiceConfiguration",
          "ec2:DescribeVpcEndpointServiceConfigurations"
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
