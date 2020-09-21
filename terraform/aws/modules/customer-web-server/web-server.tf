data "aws_region" "current" {}

data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket = "terraform-cloud-monitoring-state-bucket-${var.environment}"
    key    = "${data.aws_region.current.name}/mattermost-central-command-control"
    region = "us-east-1"
  }
}

resource "aws_security_group" "cws_postgres_sg" {
  name                   = "cws_postgres_sg"
  description            = "postgres SG for customer web server"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.cluster.outputs.workers_security_group]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.cloud_vpn_cidr
    description = "CLOUD VPN"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "postgres SG customer web server"
    Created = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

}

resource "aws_db_subnet_group" "cws_subnets_db" {
  name       = "cws_subnetgroup"
  subnet_ids = var.private_subnets

  tags = {
    Name = "customer web server DB subnet group"
  }

}

resource "aws_db_instance" "cws_postgres" {
  identifier                  = var.cws_db_identifier
  allocated_storage           = var.cws_allocated_db_storage
  storage_type                = "gp2"
  engine                      = "postgres"
  engine_version              = var.cws_db_engine_version
  instance_class              = var.cws_db_instance_class
  name                        = var.cws_db_name
  username                    = var.cws_db_username
  password                    = var.cws_db_password
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  apply_immediately           = true
  backup_retention_period     = var.cws_db_backup_retention_period
  backup_window               = var.cws_db_backup_window
  db_subnet_group_name        = aws_db_subnet_group.cws_subnets_db.name
  vpc_security_group_ids      = [aws_security_group.cws_postgres_sg.id]
  deletion_protection         = true
  final_snapshot_identifier   = "customer-web-server-final-${var.cws_db_name}"
  skip_final_snapshot         = false
  maintenance_window          = var.cws_db_maintenance_window
  publicly_accessible         = false
  # snapshot_identifier         = var.cws_snapshot_identifier
  storage_encrypted = var.cws_storage_encrypted

  tags = {
    Name        = "customer-web-server"
    Environment = var.environment
  }
}


#################### Kubernetes - Customer Web Server ###########################

resource "kubernetes_namespace" "customer_web_server" {
  metadata {
    name = var.cws_name
  }

  depends_on = [
    aws_db_instance.cws_postgres
  ]
}


resource "kubernetes_secret" "registry_customer_web_server" {
  metadata {
    name      = "${var.cws_name}-gitlab-image"
    namespace = var.cws_name

  }

  data = {
    ".dockercfg" = <<EOF
 {
      "${var.internal_registry}": {
        "username": "${var.git_user}",
        "password": "${var.git_cws_token}",
        "email": "${var.git_email}",
        "auth": "${base64encode(format("%s:%s", var.git_user, var.git_cws_token))}"
      }
    }

    EOF
  }

  type = "kubernetes.io/dockercfg"

  depends_on = [
    kubernetes_namespace.customer_web_server
  ]

  lifecycle {
    ignore_changes = [
      data,
      metadata
    ]
  }
}


resource "kubernetes_deployment" "customer_web_server" {
  metadata {
    name      = var.cws_name
    namespace = var.cws_name

    labels = {
      "app.kubernetes.io/component" = "portal"
      "app.kubernetes.io/name"      = "customer-web-server"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "portal"
        "app.kubernetes.io/name"      = "customer-web-server"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "portal"
          "app.kubernetes.io/name"      = "customer-web-server"
        }
      }

      spec {
        init_container {
          name  = "${var.cws_name}-init-database"
          image = "${var.git_image_url}:${var.cws_image_version}"
          args  = ["schema", "migrate", "--database", "$(DATABASE)"]

          env {
            name = "DATABASE"

            value_from {
              secret_key_ref {
                name = "customer-web-server-secret"
                key  = "DATABASE"
              }
            }
          }

          env {
            name = "CWS_PAYMENT_URL"

            value_from {
              secret_key_ref {
                name = "customer-web-server-secret"
                key  = "CWS_PAYMENT_URL"
              }
            }
          }

          env {
            name = "CWS_PAYMENT_TOKEN"

            value_from {
              secret_key_ref {
                name = "customer-web-server-secret"
                key  = "CWS_PAYMENT_TOKEN"
              }
            }
          }

          image_pull_policy = "Always"
        }

        image_pull_secrets {
          name = "${var.cws_name}-gitlab-image"
        }
        container {
          name  = var.cws_name
          image = "${var.git_image_url}:${var.cws_image_version}"
          args  = ["server", "--debug", "--database", "$(DATABASE)"]


          port {
            name           = "api"
            container_port = 8076
          }
          env {
            name = "DATABASE"

            value_from {
              secret_key_ref {
                name = "customer-web-server-secret"
                key  = "DATABASE"
              }
            }
          }

          env {
            name = "CWS_PAYMENT_URL"

            value_from {
              secret_key_ref {
                name = "customer-web-server-secret"
                key  = "CWS_PAYMENT_URL"
              }
            }
          }

          env {
            name = "CWS_PAYMENT_TOKEN"

            value_from {
              secret_key_ref {
                name = "customer-web-server-secret"
                key  = "CWS_PAYMENT_TOKEN"
              }
            }
          }


          image_pull_policy = "Always"
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_unavailable = "1"
      }
    }

    revision_history_limit = 2
  }

  lifecycle {
    ignore_changes = [
      metadata,
      spec,
    ]
  }

  depends_on = [
    aws_db_instance.cws_postgres,
    kubernetes_namespace.customer_web_server
  ]
}


resource "kubernetes_ingress" "customer_web_server" {
  metadata {
    name      = "${var.cws_name}-ingress"
    namespace = var.cws_name

    annotations = {
      "kubernetes.io/ingress.class" = "nginx-controller"
    }
  }

  spec {
    rule {
      host = var.cws_ingress

      http {
        path {
          path = "/"

          backend {
            service_name = "${var.cws_name}-service"
            service_port = "8076"
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      metadata,
      spec,
    ]
  }

  depends_on = [
    aws_db_instance.cws_postgres,
    kubernetes_namespace.customer_web_server
  ]
}

resource "kubernetes_secret" "cws_secret" {
  metadata {
    name      = "customer-web-server-secret"
    namespace = var.cws_name
  }

  data = {
    DATABASE          = "postgres://${var.cws_db_username}:${var.cws_db_password}@${aws_db_instance.cws_postgres.endpoint}/${var.cws_db_name}"
    CWS_PAYMENT_URL   = var.cws_payment_url
    CWS_PAYMENT_TOKEN = var.cws_payment_token
  }

  type = "Opaque"

  lifecycle {
    ignore_changes = [
      metadata,
      data,
      type,
    ]
  }

  depends_on = [
    aws_db_instance.cws_postgres
  ]
}

resource "kubernetes_service" "customer_web_server" {
  metadata {
    name      = "${var.cws_name}-service"
    namespace = var.cws_name
  }

  spec {
    port {
      name        = "api"
      port        = 8076
      target_port = "api"
    }

    selector = {
      "app.kubernetes.io/component" = "portal"
      "app.kubernetes.io/name"      = "customer-web-server"
    }

    type = "ClusterIP"
  }

  lifecycle {
    ignore_changes = [
      metadata,
      spec,
    ]
  }

  depends_on = [
    aws_db_instance.cws_postgres,
    kubernetes_namespace.customer_web_server
  ]
}

data "kubernetes_service" "nginx-public" {
  metadata {
    name      = "nginx-ingress-nginx-controller"
    namespace = "nginx"
  }
}

resource "aws_route53_record" "customer_web_server" {
  count = var.enable_portal_r53_record ? 1 : 0

  zone_id = var.public_hosted_zoneid
  name    = "portal"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-public.load_balancer_ingress.0.hostname]
}

