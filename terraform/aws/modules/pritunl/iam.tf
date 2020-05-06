resource "aws_iam_role" "r" {
  name               = "${var.name}-role"
  assume_role_policy = data.aws_iam_policy_document.sts.json
}

data "aws_iam_policy_document" "sts" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


resource "aws_iam_instance_profile" "pr" {
  name = "${var.name}-instance-profile"
  role = aws_iam_role.r.name
}

resource "aws_iam_role_policy_attachment" "aws_managed_policies" {
  count      = length(local.aws_managed_policies)
  role       = aws_iam_role.r.name
  policy_arn = element(local.aws_managed_policies, count.index)
}

