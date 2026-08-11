locals {
  project_name              = "vaultwarden"
  github_repository_subject = "${var.github_owner}@${var.github_owner_id}/${var.github_repository}@${var.github_repository_id}"
  monthly_budget_name       = "${local.project_name}-account-monthly-cost"
  alert_topic_name          = "${local.project_name}-prod-alerts"
}
