variable "environment" {}

variable "deployment_name" {}

variable "region" {}

variable "tiller_version" {}

variable "kubeconfig_dir" {}

variable "db_identifier" {}

variable "allocated_db_storage" {}

variable "db_engine_version" {}

variable "db_instance_class" {}

variable "db_name" {}

variable "db_username" {}

variable "db_password" {}

variable "db_backup_retention_period" {}

variable "db_backup_window" {}

variable "db_maintenance_window" {}

variable "vpc_id" {}

variable "private_subnets" {}

variable "storage_encrypted" {}

variable "mattermost_cloud_image" {}

variable "mattermost_cloud_ingress" {}

variable "snapshot_identifier" {}

variable "mattermost-cloud-namespace" {}

variable "mattermost_cloud_secret_ssh_private" {}

variable "mattermost_cloud_secret_ssh_public" {}

variable "mattermost_cloud_secrets_aws_access_key" {}

variable "mattermost_cloud_secrets_aws_secret_key" {}

variable "mattermost_cloud_secrets_aws_region" {}

variable "mattermost_cloud_secrets_certificate_aws_arn" {}

variable "mattermost_cloud_secrets_private_dns" {}

variable "mattermost_cloud_secrets_private_route53_id" {}

variable "mattermost_cloud_secrets_route53_id" {}

variable "grafana_tls_crt" {}

variable "grafana_tls_key" {}

variable "prometheus_tls_crt" {}

variable "prometheus_tls_key" {}

variable "kibana_tls_crt" {}

variable "kibana_tls_key" {}

variable "provisioner_user" {}
