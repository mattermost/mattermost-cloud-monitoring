provider "aws" {
  region = var.region
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.name}-redis-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name}-redis-subnet-group"
  }
}

resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id         = var.name
  engine             = "redis"
  engine_version     = var.redis_version
  node_type          = var.instance_type
  num_cache_nodes    = var.num_cache_nodes
  port               = var.port
  subnet_group_name  = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids = [aws_security_group.redis_sg.id]

  tags = {
    Name = var.name
  }
}

resource "aws_security_group" "redis_sg" {
  name        = "${var.name}-redis-sg"
  description = "Allow access to ElastiCache Redis"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-redis-sg"
  }
}
