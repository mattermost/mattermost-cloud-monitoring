data "aws_caller_identity" "current" {}

# Fetch the default KMS key for Secrets Manager
data "aws_kms_key" "default_secrets_manager_key" {
  key_id = "alias/aws/secretsmanager"
}
