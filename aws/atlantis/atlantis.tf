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

resource "aws_iam_instance_profile" "atlantis-instance-profile" {
  name = "atlantis"
  role = aws_iam_role.atlantis.name
}
