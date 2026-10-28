provider "aws" {
  region = var.region
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.name}-redis-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name}-redis-subnet-group"
  })
}

# A replication group, even for a single node: ElastiCache only supports TLS
# for Redis on replication groups.
#
# Upgrading a caller from aws_elasticache_cluster (v1.9.13 and earlier):
# `moved` cannot change resource type, so without this the plan destroys the
# old cluster. Convert the cluster to a replication group first, then in the
# caller add
#   import  { to = module.<name>.aws_elasticache_replication_group.redis, id = "<group id>" }
#   removed { from = module.<name>.aws_elasticache_cluster.redis_cluster, lifecycle { destroy = false } }
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = coalesce(var.replication_group_id, var.name)
  description          = var.description
  engine               = "redis"
  engine_version       = var.redis_version
  node_type            = var.instance_type
  num_cache_clusters   = var.num_cache_nodes
  parameter_group_name = var.parameter_group_name
  port                 = var.port
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.redis_sg.id]
  maintenance_window   = var.maintenance_window

  automatic_failover_enabled = false
  multi_az_enabled           = false

  # Changing this forces a replacement.
  at_rest_encryption_enabled = false
  transit_encryption_enabled = var.transit_encryption_enabled
  transit_encryption_mode    = var.transit_encryption_enabled ? var.transit_encryption_mode : null

  tags = merge(var.tags, {
    Name = var.name
  })
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

  tags = merge(var.tags, {
    Name = "${var.name}-redis-sg"
  })
}
