resource "aws_iam_role" "target_role" {
  name = "TargetAccountTerraformRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "target_policy" {
  name        = "TargetAccountTerraformPolicy"
  description = "IAM policy for managing EKS, NLB, and proxy instance in the target account"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:CreateCluster",
          "eks:DescribeCluster",
          "eks:DeleteCluster",
          "ec2:RunInstances",
          "ec2:DescribeInstances",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:DescribeLoadBalancers",
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

resource "aws_iam_role_policy_attachment" "target_role_attachment" {
  role       = aws_iam_role.target_role.name
  policy_arn = aws_iam_policy.target_policy.arn
}
