data "aws_caller_identity" "current" {}

# The ssh keypair created for the bind server
resource "aws_key_pair" "bind" {
  key_name   = "mattermost-cloud-${var.environment}-bind"
  public_key = var.ssh_key_public
}

resource "aws_iam_instance_profile" "bind-server-instance-profile" {
  name = "${var.environment}-bind-server-instance-profile"
  role = aws_iam_role.bind-server-role.name
}

resource "aws_iam_role" "bind-server-role" {
  name = "${var.environment}-bind-server-role"

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

resource "aws_iam_role_policy_attachment" "bind-cloudwatch-agent" {
  count = length(local.role_policy_arn)

  role       = aws_iam_role.bind-server-role.name
  policy_arn = element(local.role_policy_arn, count.index)
}
