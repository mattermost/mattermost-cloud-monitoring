resource "aws_s3_bucket" "gitlab_registry" {
  bucket = "mattermost-cloud-gitlab-registry-storage"
  region = "us-east-1"
  acl    = "private"
}

resource "aws_s3_bucket" "gitlab_lfs" {
  bucket = "mattermost-cloud-gitlab-lfs-storage"
  region = "us-east-1"
  acl    = "private"
}

resource "aws_s3_bucket" "gitlab_artifacts" {
  bucket = "mattermost-gitlab-artifacts-storage"
  region = "us-east-1"
  acl    = "private"
}

resource "aws_s3_bucket" "gitlab_uploads" {
  bucket = "mattermost-gitlab-uploads-storage"
  region = "us-east-1"
  acl    = "private"
}

resource "aws_s3_bucket" "gitlab_packages" {
  bucket = "mattermost-gitlab-packages-storage"
  region = "us-east-1"
  acl    = "private"
}

resource "aws_s3_bucket" "gitlab_backup" {
  bucket = "mattermost-gitlab-backup-storage"
  region = "us-east-1"
  acl    = "private"
}

resource "aws_s3_bucket" "gitlab_backup_tmp" {
  bucket = "mattermost-gitlab-tmp-storage"
  region = "us-east-1"
  acl    = "private"
}
