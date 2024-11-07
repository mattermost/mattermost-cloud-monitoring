resource "aws_efs_file_system" "efs" {
  count            = var.enabled_efs ? 1 : 0
  creation_token   = "${var.deployment_name}-${var.environment}-efs"
  performance_mode = var.efs_performance_mode
  throughput_mode  = var.efs_throughput_mode
  tags = {
    Name        = "${var.deployment_name}-${var.environment}-efs"
    Environment = var.environment
  }
}

resource "aws_efs_mount_target" "efs_mount" {
  count           = var.enabled_efs ? length(var.private_subnet_ids) : 0
  file_system_id  = aws_efs_file_system.efs[0].id
  subnet_id       = element(var.private_subnet_ids, count.index)
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_security_group" "efs_sg" {
  count  = var.enabled_efs ? 1 : 0
  name   = "${var.deployment_name}-${var.environment}-efs-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_ids
  }

  tags = {
    Name        = "${var.deployment_name}-${var.environment}-efs-sg"
    Environment = var.environment
  }
}
