resource "kubernetes_secret" "rails_secret" {
  metadata {
    name      = "gitlab-rails-storage"
    namespace = "gitlab"
  }

  data = {
    "connection" = "aws_access_key_id: ${var.gitlab_s3_bucket_access_key_id}\naws_secret_access_key: ${var.gitlab_s3_bucket_secret_access_key}\nregion: ${var.gitlab_aws_region}\nprovider: AWS\n"
  }

  type = "Opaque"
}

resource "kubernetes_secret" "registry_secret" {
  metadata {
    name      = "gitlab-registry-storage"
    namespace = "gitlab"
  }


  data = {
    "config" = "s3:\n  bucket: ${aws_s3_bucket.gitlab_registry.bucket}\n  accesskey: ${var.gitlab_s3_bucket_access_key_id}\n  secretkey: ${var.gitlab_s3_bucket_secret_access_key}\n  region: ${var.gitlab_aws_region}\n  v4auth: true\n"

    type = "Opaque"
  }
}

resource "kubernetes_secret" "storage_config_secret" {
  metadata {
    name      = "storage-config"
    namespace = "gitlab"
  }

  data = {
    "config" = "[default]\naccess_key = ${var.gitlab_s3_bucket_access_key_id}\nsecret_key = ${var.gitlab_s3_bucket_secret_access_key}\nbucket_location: ${var.gitlab_aws_region}\n"

    type = "Opaque"
  }
}

resource "kubernetes_secret" "postgres_secret" {
  metadata {
    name      = "gitlab-postgres-secret"
    namespace = "gitlab"
  }

  data = {
    "password" = var.db_password

    type = "Opaque"
  }
}

resource "kubernetes_secret" "smtp_secret" {
  metadata {
    name      = "gitlab-smtp"
    namespace = "gitlab"
  }

  data = {
    "password" = var.smtp_password

    type = "Opaque"
  }
}
