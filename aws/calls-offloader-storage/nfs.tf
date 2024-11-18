resource "aws_security_group" "nfs_sg" {
  for_each    = var.enabled_nfs ? var.vpc_configurations : {}
  name        = "${each.key}-nfs-sg"
  description = "Security group for NFS server, allowing NFS (port 2049) access from specified private subnets."
  vpc_id      = each.value.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = each.value.subnet_ids
    description = "Allow port 2049"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outgoing traffic"
  }

  tags = {
    Name        = "${each.key}-nfs-sg"
    Environment = var.environment
  }
}

resource "aws_instance" "nfs_server" {
  for_each        = var.enabled_nfs ? var.vpc_configurations : {}
  ami             = var.ami_id
  instance_type   = var.instance_type
  ebs_optimized   = true
  subnet_id       = element(each.value.subnet_ids, 0)
  security_groups = [aws_security_group.nfs_sg[each.key].id]
  monitoring      = var.detailed_monitoring
  metadata_options {

    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_type = var.volume_type
    volume_size = var.root_volume_size
    encrypted   = true
    kms_key_id  = var.root_kms_key_id != "" ? var.root_kms_key_id : null
  }

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
    Name        = "${each.key}-nfs-server"
    Environment = var.environment
  }
}

resource "aws_ebs_volume" "nfs_storage" {
  for_each          = var.enabled_nfs ? var.vpc_configurations : {}
  availability_zone = aws_instance.nfs_server[each.key].availability_zone
  size              = var.nfs_storage_size
  encrypted         = var.nfs_encrypted
  kms_key_id        = var.nfs_kms_key_id != "" ? var.nfs_kms_key_id : null

  tags = {
    Name        = "${each.key}-nfs-storage"
    Environment = var.environment
  }
}

resource "aws_volume_attachment" "nfs_attachment" {
  for_each     = var.enabled_nfs ? var.vpc_configurations : {}
  device_name  = "/dev/xvdb"
  volume_id    = aws_ebs_volume.nfs_storage[each.key].id
  instance_id  = aws_instance.nfs_server[each.key].id
  force_detach = true
}
