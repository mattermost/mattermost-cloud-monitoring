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

data "aws_subnet" "efs_subnets" {
  for_each = toset(flatten([for vpc_name, vpc_config in var.vpc_configurations : vpc_config.subnet_ids]))
  id       = each.value
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
    cidr_blocks = [for subnet in var.vpc_configurations[each.key].subnet_ids : data.aws_subnet.efs_subnets[subnet].cidr_block]
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

locals {
  efs_mount_targets = var.enabled_efs ? flatten([
    for vpc_name, vpc_config in var.vpc_configurations : [
      for subnet_id in vpc_config.subnet_ids : {
        key            = "${vpc_name}-${subnet_id}"
        subnet_id      = subnet_id
        vpc_id         = vpc_config.vpc_id
        security_group = aws_security_group.efs_sg[vpc_name].id
        file_system_id = aws_efs_file_system.efs[vpc_name].id
      }
    ]
  ]) : []
}

resource "aws_efs_mount_target" "efs_mount" {
  for_each = { for obj in local.efs_mount_targets : obj.key => obj }

  subnet_id       = each.value.subnet_id
  security_groups = [each.value.security_group]
  file_system_id  = each.value.file_system_id
}





