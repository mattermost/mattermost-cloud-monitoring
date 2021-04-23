data "aws_ami" "ubuntu_image" {
  most_recent = true
  owners      = [var.ubuntu_account_number]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "AmazonVPCReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonVPCReadOnlyAccess"
}

data "aws_iam_policy" "AmazonRoute53ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonRoute53ReadOnlyAccess"
}
