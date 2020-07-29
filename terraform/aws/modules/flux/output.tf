output "post_installation_message" {
  value = <<EOF
  Do not forget to run fluxctl identity and add the public key to Gitlab/GitHub.
  After the initial setup the Mattermost provisioner resources are managed by Flux and cannot be updated via Terrrform.
  EOF
}
