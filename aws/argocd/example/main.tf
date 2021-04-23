module "argocd" {
  source                      = "github.com/mattermost/mattermost-terraform-modules.git//aws/argocd?ref=v1.0.0"
  argocd_chart_version        = "3.33.5"
  argo_chart_values_directory = "charts-values/argod.yaml"
}
