resource "aws_key_pair" "stitch-blapi" {
  key_name   = var.key_name
  public_key = var.public_key

  tags = var.tags
}

resource "aws_security_group" "stitch-group" {
  name                   = "allow_stitch_ips"
  description            = "Allow K8s C&C to access RDS Postgres"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  ingress {
    from_port = 22
    protocol  = "TCP"
    to_port   = 22

    cidr_blocks = var.stitch_ips
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.vpc_security_group_ids
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "connect-ec2-rds" {
  name                   = "connect_ec2_rds"
  description            = "Allow instance to access RDS Postgres"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  tags = var.tags
}

resource "aws_security_group" "connect-rds-ec2" {
  name                   = "connect_rds_ec2"
  description            = "Allow ec2 bastion to access RDS Postgres"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  ingress {
    from_port       = 5432
    protocol        = "TCP"
    to_port         = 5432
    security_groups = [aws_security_group.connect-ec2-rds.id]
  }

  tags = var.tags
}

resource "aws_security_group_rule" "connect-ec2-rds-to-connect-rds-ec2" {
  type                     = "egress"
  security_group_id        = aws_security_group.connect-ec2-rds.id
  source_security_group_id = aws_security_group.connect-rds-ec2.id
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
}


resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  source_dest_check           = var.source_dest_check
  disable_api_termination     = var.disable_api_termination
  monitoring                  = var.monitoring
  key_name                    = aws_key_pair.stitch-blapi.key_name

  user_data = file("${var.filepath}/templates/userdata.yml")

  tags = var.tags

  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    delete_on_termination = var.delete_on_termination
  }

  vpc_security_group_ids = [aws_security_group.stitch-group.id, aws_security_group.connect-ec2-rds.id]

  credit_specification {
    cpu_credits = var.cpu_credits
  }
}

resource "aws_eip" "bastion_ip" {
  instance = aws_instance.bastion.id
  vpc      = true
}
