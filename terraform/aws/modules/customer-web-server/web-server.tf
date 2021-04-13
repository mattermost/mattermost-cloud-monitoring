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

resource "aws_db_instance" "cws_postgres_read_replica" {
  identifier                  = local.db_identifier_read_replica
  name                        = local.db_name_read_replica
  instance_class              = var.cws_db_instance_class
  storage_type                = "gp2"
  storage_encrypted           = var.cws_storage_encrypted
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  apply_immediately           = true
  deletion_protection         = true

  # networking
  db_subnet_group_name   = aws_db_subnet_group.cws_subnets_db.name
  vpc_security_group_ids = [aws_security_group.cws_postgres_sg.id]
  publicly_accessible    = false

  # backup & maintenance
  backup_retention_period   = var.cws_db_backup_retention_period
  backup_window             = var.cws_db_backup_window
  maintenance_window        = var.cws_db_maintenance_window
  final_snapshot_identifier = "customer-web-server-final-${local.db_name_read_replica}-${local.timestamp_now}"
  skip_final_snapshot       = false

  # replication read replica
  replicate_source_db = aws_db_instance.cws_postgres.identifier

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

          env_from {
            secret_ref {
              name = "customer-web-server-secret"
            }
          }

          image_pull_policy = "IfNotPresent"
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

          port {
            name           = "internal"
            container_port = 8077
          }

          env_from {
            secret_ref {
              name = "customer-web-server-secret"
            }
          }

          image_pull_policy = "IfNotPresent"
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
      "kubernetes.io/ingress.class" = "nginx"
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
    tls {
      hosts = [var.cws_ingress]
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

resource "kubernetes_ingress" "customer_web_server_internal" {
  metadata {
    name      = "${var.cws_name}-internal-ingress"
    namespace = var.cws_name

    annotations = {
      "kubernetes.io/ingress.class" = "nginx-controller"
    }
  }

  spec {
    rule {
      host = var.cws_ingress_internal

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
    tls {
      hosts = [var.cws_ingress_internal]
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

resource "kubernetes_ingress" "customer_web_server_api_internal" {
  count = var.enable_portal_internal_components ? 1 : 0

  metadata {
    name      = "${var.cws_name}-api-internal-ingress"
    namespace = var.cws_name

    annotations = {
      "kubernetes.io/ingress.class" = "nginx-controller"
    }
  }

  spec {
    rule {
      host = var.cws_ingress_api_internal

      http {
        path {
          path = "/"

          backend {
            service_name = "${var.cws_name}-service"
            service_port = "8077"
          }
        }
      }
    }
    tls {
      hosts = [var.cws_ingress_api_internal]
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
    DATABASE                        = "postgres://${var.cws_db_username}:${var.cws_db_password}@${aws_db_instance.cws_postgres.endpoint}/${var.cws_db_name}"
    CWS_STRIPE_KEY                  = var.cws_stripe_key
    CWS_SITEURL                     = var.cws_ingress
    CWS_SMTP_USERNAME               = var.cws_smtp_username
    CWS_SMTP_PASSWORD               = var.cws_smtp_password
    CWS_SMTP_SERVER                 = var.cws_smtp_host
    CWS_SMTP_PORT                   = var.cws_smtp_port
    CWS_SMTP_SERVERTIMEOUT          = "10"
    CWS_SMTP_CONNECTIONSECURITY     = "TLS"
    CWS_EMAIL_REPLYTONAME           = "Mattermost"
    CWS_EMAIL_REPLYTOADDRESS        = var.cws_email_replyto_address
    CWS_EMAIL_BCCADDRESSES          = var.cws_bcc_addresses
    CWS_BLAPI_URL                   = var.cws_blapi_url
    CWS_BLAPI_TOKEN                 = var.cws_blapi_token
    CWS_CLOUD_URL                   = var.cws_cloud_url
    CWS_CLOUD_DNS_DOMAIN            = var.cws_cloud_dns_domain
    CWS_CLOUD_GROUP_ID              = var.cws_cloud_group_id
    CWS_LICENSE_GENERATOR_KEY       = var.cws_license_generator_key
    CWS_LICENSE_GENERATOR_URL       = var.cws_license_generator_url
    STRIPE_WEBHOOK_SIGNATURE_SECRET = var.cws_stripe_webhook_secret
    CWS_DESCARTES_USER              = var.cws_descartes_user
    CWS_DESCARTES_PASS              = var.cws_descartes_pass
    CWS_DESCARTES_URL               = var.cws_descartes_url
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

    port {
      name        = "internal"
      port        = 8077
      target_port = "internal"
    }

    selector = {
      "app.kubernetes.io/component" = "portal"
      "app.kubernetes.io/name"      = "customer-web-server"
    }

    type = "NodePort"
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

data "kubernetes_service" "nginx-private" {
  metadata {
    name      = "nginx-internal-ingress-nginx-controller"
    namespace = "nginx-internal"
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

resource "aws_route53_record" "customer_web_server_internal" {
  count = var.enable_portal_r53_record ? 1 : 0

  zone_id = var.private_hosted_zoneid
  name    = "portal"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-private.load_balancer_ingress.0.hostname]
}

resource "aws_route53_record" "customer_web_server_api_internal" {
  count = var.enable_portal_internal_r53_record ? 1 : 0

  zone_id = var.private_hosted_zoneid
  name    = "api"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-private.load_balancer_ingress.0.hostname]
}
