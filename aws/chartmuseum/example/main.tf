module "chartmuseum" {
  source                             = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/chartmuseum?ref=1.6.0"
  deployment_name                    = var.deployment_name
  kubeconfig_dir                     = var.kubeconfig_dir
  chartmuseum_chart_values_directory = var.chartmuseum_chart_values_directory
  chartmuseum_bucket                 = var.chartmuseum_bucket
  chartmuseum_user_key_id            = var.chartmuseum_user_key_id
  chartmuseum_user_access_key        = var.chartmuseum_user_access_key
  chartmuseum_hostname               = var.chartmuseum_hostname
  private_hosted_zoneid              = var.private_hosted_zoneid
}

