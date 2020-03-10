resource "null_resource" "gitlab_crd" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${var.kubeconfig_dir}/kubeconfig apply -f https://gitlab.com/gitlab-org/charts/gitlab/raw/${var.gitlab_chart_version}/support/crd.yaml" 
  }
}

resource "helm_release" "gitlab" {
  name  = "gitlab"
  chart = "gitlab/gitlab"
  namespace  = "gitlab"
  values = [
    "${file("../../../modules/gitlab/chart_values.yaml")}"
  ]

  set {
    name  = "global.hosts.domain"
    value = var.gitlab_domain
  }

  set {
    name = "global.psql.database"
    value = var.db_name
  }

  set {
    name = "global.psql.username"
    value = var.db_username
  }

  set {
    name = "global.psql.host"
    value = aws_db_instance.gitlab.address
  }

  set {
    name  = "nginx-ingress.controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = aws_acm_certificate.gitlab_cert.arn
  }

  set {
    name = "gitlab-runner.install"
    value = var.install_gitlab_runner
  }

  set {
    name = "global.registry.bucket"
    value = var.gitlab_registry_bucket
  }

  set {
    name = "global.appConfig.lfs.bucket"
    value = var.gitlab_lfs_bucket
  }

  set {
    name = "global.appConfig.artifacts.bucket"
    value = var.gitlab_artifacts_bucket
  }

  set {
    name = "global.appConfig.uploads.bucket"
    value = var.gitlab_uploads_bucket
  }

  set {
    name = "global.appConfig.packages.bucket"
    value = var.gitlab_packages_bucket
  }

  set {
    name = "global.appConfig.backups.bucket"
    value = var.gitlab_backup_bucket
  }

  set {
    name = "global.appConfig.backups.tmpBucket"
    value = var.gitlab_tmp_bucket
  }


  depends_on = [
    null_resource.gitlab_crd,
    aws_s3_bucket.gitlab_registry,
    aws_s3_bucket.gitlab_lfs,
    aws_s3_bucket.gitlab_artifacts,
    aws_s3_bucket.gitlab_uploads,
    aws_s3_bucket.gitlab_packages,
    aws_s3_bucket.gitlab_backup,
    aws_s3_bucket.gitlab_backup_tmp,
    aws_db_instance.gitlab,
    kubernetes_secret.rails_secret,
    kubernetes_secret.registry_secret,
    kubernetes_secret.storage_config_secret,
    kubernetes_secret.postgres_secret
  ]
  
  timeout = 1200

}
