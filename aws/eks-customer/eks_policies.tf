resource "aws_iam_policy" "node" {
  name        = "eks-customer-node-${module.eks.cluster_name}"
  path        = "/"
  description = "Policy for eks-customer node."

  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "s3:ListBucket",
                "s3:ListBucketVersions",
                "s3:CreateBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::cloud-${var.environment}-*"
            ],
            "Sid": "AllS3Bucket"
        },
        {
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:DeleteObject*"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::cloud-${var.environment}-*/*"
            ],
            "Sid": "AllS3Object"
        },
        {
            "Action": [
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:DescribeInstances",
                "ec2:DeleteTags",
                "ec2:DescribeRegions",
                "ec2:DescribeSnapshots",
                "ec2:DeleteVolume",
                "ec2:DescribeVolumeStatus",
                "ec2:DeleteNetworkInterfacePermission",
                "ec2:StartInstances",
                "ec2:CreateNetworkInterfacePermission",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeVolumes",
                "ec2:DescribeReservedInstances",
                "ec2:DescribeReservedInstancesListings",
                "ec2:DescribeInstanceStatus",
                "ec2:DetachVolume",
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:ModifyVolume",
                "ec2:TerminateInstances",
                "ec2:DescribeTags",
                "ec2:CreateTags",
                "ec2:RunInstances",
                "ec2:StopInstances",
                "ec2:DescribeSecurityGroups",
                "ec2:CreateVolume",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeLaunchTemplateVersions",
                "ec2:GetLaunchTemplateData",
                "ec2:ModifyLaunchTemplate",
                "ec2:CreateLaunchTemplate",
                "ec2:CreateLaunchTemplateVersion",
                "ec2:DeleteLaunchTemplate",
                "ec2:CreateLaunchTemplateVersion",
                "ec2:DescribeImages",
                "ec2:DescribeVpcs",
                "ec2:AttachNetworkInterface",
                "ec2:DescribeSubnets",
                "ec2:ImportKeyPair",
                "ec2:DeleteKeyPair",
                "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:CreateTargetGroup",
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeInstanceHealth",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeListenerAttributes",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:CreateLoadBalancerListeners",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:ConfigureHealthCheck",
                "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
                "elasticloadbalancing:AttachLoadBalancerToSubnets",
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:DeleteTargetGroup",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:ModifyListenerAttributes",
                "autoscaling:CreateLaunchConfiguration",
                "autoscaling:DescribeTags",
                "autoscaling:DeleteTags",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:CreateAutoScalingGroup",
                "autoscaling:DeleteLaunchConfiguration",
                "autoscaling:DeleteAutoScalingGroup",
                "autoscaling:DescribeScalingActivities",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:UpdateAutoScalingGroup",
                "autoscaling:EnableMetricsCollection",
                "autoscaling:AttachLoadBalancers",
                "autoscaling:DetachLoadBalancers",
                "autoscaling:DescribeLoadBalancers",
                "autoscaling:DetachInstances",
                "autoscaling:SuspendProcesses",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "autoscaling:CreateOrUpdateTags",
                "autoscaling:DescribeWarmPool",
                "autoscaling:DescribeAutoscalingInstances",
                "autoscaling:DescribeLifecycleHooks",
                "autoscaling:CompleteLifecycleAction",
                "autoscaling:SetInstanceProtection",
                "autoscaling:PutLifecycleHook",
                "autoscaling:DeleteLifecycleHook",
                "acm:ListCertificates",
                "acm:ListTagsForCertificate",
                "sqs:ListQueues",
                "sqs:CreateQueue",
                "sqs:TagQueue",
                "sqs:GetQueueAttributes",
                "sqs:ListQueueTags",
                "sqs:DeleteQueue",
                "events:ListRules",
                "events:TagResource",
                "events:PutRule",
                "events:DescribeRule",
                "events:ListTagsForResource",
                "events:DeleteRule",
                "events:PutTargets",
                "events:ListTargetsByRule",
                "events:RemoveTargets",
                "elasticfilesystem:DescribeMountTargets"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        }
    ],
    "Version": "2012-10-17"
}
EOF
}
