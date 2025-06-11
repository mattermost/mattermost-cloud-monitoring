variable "environment" {
  description = "The environment"
  type        = string
}


variable "github_runners_iam_role_arn" {
  description = "Github runner role ARN"
  type        = string
}

variable "github_repos_sub" {
  description = "Github repos sub"
  type        = list(string)
}
