data "github_app_token" "this" {
  app_id          = var.github_app_id
  installation_id = var.github_app_installation_id
  pem_file        = file(var.github_app_pem_key_path)
}
