resource "kubernetes_namespace" "atlantis" {
  metadata {
    name = "atlantis"
  }
}

resource "helm_release" "atlantis" {
  name       = "atlantis"
  chart      = "atlantis"
  repository = "https://runatlantis.github.io/helm-charts"
  namespace  = "atlantis"
  version    = var.atlantis_chart_version
  values = [
    file(var.atlantis_chart_values_directory)
  ]

  set {
    name  = "orgWhitelist"
    value = var.org_whitelist
  }

  set {
    name  = "gitlab.user"
    value = var.gitlab_user
  }

  set {
    name  = "gitlab.token"
    value = var.gitlab_token
  }

  set {
    name  = "gitlab.secret"
    value = var.gitlab_webhook_secret
  }

  set {
    name  = "gitlab.hostname"
    value = var.gitlab_hostname
  }

  set {
    name  = "ingress.host"
    value = var.atlantis_hostname
  }

  set {
    name  = "tls.hosts"
    value = var.atlantis_hostname
  }

  # the AWS credentials will be created manually and we will set here the secret name that was created
  set {
    name  = "awsSecretName"
    value = var.aws_secretname
  }

  set {
    name  = "defaultTFVersion"
    value = var.terraform_default_version
  }


  depends_on = [
    kubernetes_namespace.atlantis,
    helm_release.internal_nginx,
  ]

  timeout = 1200

}

resource "aws_iam_role" "atlantis" {
  name = "atlantis"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_security_group" "atlantis-sg" {
  description = "atlatis-sg"
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "gitlab"
    from_port   = 4141
    protocol    = "tcp"
    to_port     = 4141
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "gitlab"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "gitlab"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
  ingress {
    cidr_blocks = [
      "10.247.4.47/32",
      "10.247.0.6/32",
      "10.247.16.6/32",
    ]
    from_port = 4141
    protocol  = "tcp"
    to_port   = 4141

  }

}
resource "aws_iam_instance_profile" "atlantis-instance-profile" {
  name = "atlantis"
  role = aws_iam_role.atlantis.name
}

resource "aws_launch_configuration" "atlantis-lc" {
  iam_instance_profile        = aws_iam_instance_profile.atlantis-instance-profile.name
  image_id                    = var.ami_id
  instance_type               = var.instance_type
  name_prefix                 = var.deployment_name
  security_groups             = var.security_groups
  associate_public_ip_address = false
  key_name                    = var.key_name

  root_block_device {
    volume_size = var.volume_size
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "atlantis-asg" {
  desired_capacity     = var.desired_capacity
  launch_configuration = aws_launch_configuration.atlantis-lc.id
  max_size             = var.max_size
  min_size             = var.min_size
  name                 = "${var.atlantis_deployment_name}-atlantis-asg"
  vpc_zone_identifier  = [var.subnet_id]
  termination_policies = ["OldestInstance"]

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "Atlantis"
  }

  tag {
    key                 = "Environment"
    propagate_at_launch = true
    value               = var.environment
  }
}
