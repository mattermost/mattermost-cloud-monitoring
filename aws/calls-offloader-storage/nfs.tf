resource "aws_security_group" "nfs_sg" {
  count  = var.enabled_nfs ? 1 : 0
  name   = "${var.deployment_name}-${var.environment}-nfs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = var.nfs_security_group_ingress_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.deployment_name}-${var.environment}-nfs-sg"
    Environment = var.environment
  }
}

resource "aws_instance" "nfs_server" {
  count           = var.enabled_nfs ? 1 : 0
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = element(var.private_subnet_ids, 0)
  security_groups = [aws_security_group.nfs_sg[0].name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nfs-utils
              mkfs -t ext4 /dev/xvdb
              mkdir -p /mnt/nfs_share
              mount /dev/xvdb /mnt/nfs_share
              chmod 777 /mnt/nfs_share
              echo "/mnt/nfs_share *(rw,sync,no_root_squash,no_subtree_check)" > /etc/exports
              exportfs -a
              systemctl enable nfs
              systemctl start nfs
            EOF

  tags = {
    Name        = "${var.deployment_name}-${var.environment}-nfs-server"
    Environment = var.environment
  }
}

resource "aws_ebs_volume" "nfs_storage" {
  count             = var.enabled_nfs ? 1 : 0
  availability_zone = aws_instance.nfs_server[0].availability_zone
  size              = var.nfs_storage_size

  tags = {
    Name        = "${var.deployment_name}-${var.environment}-nfs-storage"
    Environment = var.environment
  }
}

resource "aws_volume_attachment" "nfs_attachment" {
  count        = var.enabled_nfs ? 1 : 0
  device_name  = "/dev/xvdb"
  volume_id    = aws_ebs_volume.nfs_storage[0].id
  instance_id  = aws_instance.nfs_server[0].id
  force_detach = true
}

