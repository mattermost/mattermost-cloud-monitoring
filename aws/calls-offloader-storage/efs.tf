resource "aws_efs_file_system" "efs" {
  for_each         = var.enabled_efs ? var.vpc_configurations : {}
  creation_token   = "${each.key}-efs"
  performance_mode = var.efs_performance_mode
  throughput_mode  = var.efs_throughput_mode
  encrypted        = var.efs_encrypted

  kms_key_id = var.efs_kms_key_id != "" ? var.efs_kms_key_id : null

  tags = {
    Name        = "${each.key}-efs"
    Environment = var.environment
  }
}


resource "aws_security_group" "efs_sg" {
  for_each    = var.enabled_efs ? var.vpc_configurations : {}
  name        = "${each.key}-efs-sg"
  description = "Security group for EFS, allowing NFS (port 2049) access from specified private subnets."
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
    Name        = "${each.key}-efs-sg"
    Environment = var.environment
  }
}

resource "aws_efs_mount_target" "efs_mount" {
  for_each = var.enabled_efs ? {
    for vpc_name, vpc_config in var.vpc_configurations :
    vpc_name => flatten([for subnet_id in vpc_config.subnet_ids : {
      vpc_id         = vpc_config.vpc_id
      subnet_id      = subnet_id
      security_group = aws_security_group.efs_sg[vpc_name].id
      file_system_id = aws_efs_file_system.efs[vpc_name].id
    }])
  } : {}

  subnet_id       = each.value.subnet_id
  security_groups = [each.value.security_group]
  file_system_id  = each.value.file_system_id
}

