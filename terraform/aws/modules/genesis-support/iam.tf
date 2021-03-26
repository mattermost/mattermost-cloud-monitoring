resource "aws_iam_role" "tgw_share_association_assume_role" {
  name = "tgw-share-association-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
            "arn:aws:iam::${var.test_account_id}:root",
            "arn:aws:iam::${var.prod_account_id}:root"
        ]
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "tgw_share_association_policy" {
  name = "tgw-share-association-policy"
  role = aws_iam_role.tgw_share_association_assume_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowPrincipalAssociationsWithTGW",
            "Effect": "Allow",
            "Action": [
                "ram:AssociateResourceShare",
                "ram:DisassociateResourceShare"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
