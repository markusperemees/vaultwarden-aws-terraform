output "state_bucket_name" {
  description = "Terraform state bucket name"
  value       = aws_s3_bucket.terraform_state.id
}

output "state_bucket_arn" {
  description = "Terraform state bucket ARN"
  value       = aws_s3_bucket.terraform_state.arn
}

output "github_terraform_plan_role_arn" {
  description = "ARN of the GitHub Actions Terraform plan role."
  value       = aws_iam_role.github_terraform_plan.arn
}