################################################################################
# MSK Serverless Cluster for Mimir Ingest Storage
#
# Provides durable Kafka-compatible ingestion pipeline for Mimir's ingest
# storage architecture. Distributors produce to Kafka; ingesters consume from
# partitions asynchronously, decoupling the write and read paths.
################################################################################

resource "aws_msk_serverless_cluster" "mimir_ingest" {
  count        = var.enable_msk ? 1 : 0
  cluster_name = "mimir-ingest-${var.environment}"

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.msk_mimir[0].id]
  }

  client_authentication {
    sasl {
      iam {
        enabled = true
      }
    }
  }

  tags = merge(var.tags, {
    Name      = "mimir-ingest-${var.environment}"
    Component = "mimir"
    ManagedBy = "terraform"
  })
}

################################################################################
# Security Group for MSK
################################################################################

resource "aws_security_group" "msk_mimir" {
  count       = var.enable_msk ? 1 : 0
  name_prefix = "mimir-msk-${var.environment}-"
  description = "Security group for Mimir MSK Serverless cluster"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Kafka IAM auth from EKS nodes"
    from_port       = 9098
    to_port         = 9098
    protocol        = "tcp"
    security_groups = [var.eks_node_security_group_id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name      = "mimir-msk-${var.environment}"
    Component = "mimir"
    ManagedBy = "terraform"
  })

  lifecycle {
    create_before_destroy = true
  }
}
