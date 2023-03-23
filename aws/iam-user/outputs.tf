output "iam_user_name" {
  description = "The user's name"
  value       = try(aws_iam_user.this[0].name, "")
}

output "iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = try(aws_iam_user.this[0].arn, "")
}

output "iam_user_unique_id" {
  description = "The unique ID assigned by AWS"
  value       = try(aws_iam_user.this[0].unique_id, "")
}

output "iam_user_login_profile_password" {
  description = "The user password"
  value       = lookup(try(aws_iam_user_login_profile.this[0], {}), "password", sensitive(""))
  sensitive   = true
}

output "iam_access_key_id" {
  description = "The access key ID"
  value       = try(aws_iam_access_key.this[0].id, aws_iam_access_key.this[0].id, "")
}

output "iam_access_key_secret" {
  description = "The access key secret"
  value       = try(aws_iam_access_key.this[0].secret, "")
  sensitive   = true
}

output "iam_access_key_status" {
  description = "Active or Inactive. Keys are initially active, but can be made inactive by other means."
  value       = try(aws_iam_access_key.this[0].status, aws_iam_access_key.this[0].status, "")
}

output "iam_user_ssh_key_ssh_public_key_id" {
  description = "The unique identifier for the SSH public key"
  value       = try(aws_iam_user_ssh_key.this[0].ssh_public_key_id, "")
}

output "iam_user_ssh_key_fingerprint" {
  description = "The MD5 message digest of the SSH public key"
  value       = try(aws_iam_user_ssh_key.this[0].fingerprint, "")
}
