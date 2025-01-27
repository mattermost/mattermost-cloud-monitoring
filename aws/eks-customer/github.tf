data "github_app_token" "this" {
  app_id          = var.app_id
  installation_id = var.installation_id
  pem_file        = file(var.github_app_pem_key_path)
}
