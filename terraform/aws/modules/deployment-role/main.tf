resource "aws_iam_role" "deployment-role" {
  name = "${var.deployment_name}-${var.environment}-deployment-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "deployment-role-admin-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = "${aws_iam_role.deployment-role.name}"
}
