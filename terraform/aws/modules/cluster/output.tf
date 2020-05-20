output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

output "worker_security_group" {
  value = aws_security_group.worker-sg.id
}

output "worker-role" {
  value = aws_iam_role.worker-role.id
}

output "cluster-sg" {
  value = aws_security_group.cluster-sg.id
}

output "lambda_role_name" {
  value = data.aws_region.current.name == "us-east-1" ? aws_iam_role.lambda_role[0].name : data.aws_iam_role.lambda_role[0].name
}

output "lambda_role_id" {
  value = data.aws_region.current.name == "us-east-1" ? aws_iam_role.lambda_role[0].id : data.aws_iam_role.lambda_role[0].id
}

output "lambda_role_arn" {
  value = data.aws_region.current.name == "us-east-1" ? aws_iam_role.lambda_role[0].arn : data.aws_iam_role.lambda_role[0].arn
}
