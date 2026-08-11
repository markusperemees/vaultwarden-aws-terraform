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

output "github_ecr_push_role_arn" {
  description = "ARN of the GitHub Actions ECR push role."
  value       = aws_iam_role.github_ecr_push.arn
}

output "github_terraform_apply_role_arn" {
  description = "ARN of the GitHub Actions Terraform apply role."
  value       = aws_iam_role.github_terraform_apply.arn
}

output "monthly_account_budget_arn" {
  description = "ARN of the account-wide monthly AWS cost budget."
  value       = aws_budgets_budget.monthly_account_cost.arn
}

output "monthly_account_budget_name" {
  description = "Name of the account-wide monthly AWS cost budget."
  value       = aws_budgets_budget.monthly_account_cost.name
}

output "alert_topic_arn" {
  description = "ARN of the shared SNS topic for AWS cost and operational alerts."
  value       = aws_sns_topic.alerts.arn
}
