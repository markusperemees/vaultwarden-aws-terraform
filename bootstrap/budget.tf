data "aws_caller_identity" "current" {}

resource "aws_budgets_budget" "monthly_account_cost" {
  account_id   = data.aws_caller_identity.current.account_id
  name         = "${local.project_name}-account-monthly-cost"
  budget_type  = "COST"
  limit_amount = var.monthly_budget_limit_usd
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  tags = {
    Name = "${local.project_name}-account-monthly-cost"
  }
}
