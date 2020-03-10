resource "aws_s3_bucket" "gitlab_registry" {
  bucket = var.gitlab_registry_bucket
  region = "us-east-1"
  acl    = "private"
}

resource "aws_s3_bucket" "gitlab_lfs" {
  bucket = var.gitlab_lfs_bucket
  region = "us-east-1"
  acl    = "private"
}

resource "aws_s3_bucket" "gitlab_artifacts" {
  bucket = var.gitlab_artifacts_bucket
  region = "us-east-1"
  acl    = "private"
}

resource "aws_s3_bucket" "gitlab_uploads" {
  bucket = var.gitlab_uploads_bucket
  region = "us-east-1"
  acl    = "private"
}

resource "aws_s3_bucket" "gitlab_packages" {
  bucket = var.gitlab_packages_bucket
  region = "us-east-1"
  acl    = "private"
}

resource "aws_s3_bucket" "gitlab_backup" {
  bucket = var.gitlab_backup_bucket
  region = "us-east-1"
  acl    = "private"
}

resource "aws_s3_bucket" "gitlab_backup_tmp" {
  bucket = var.gitlab_tmp_bucket
  region = "us-east-1"
  acl    = "private"
}
