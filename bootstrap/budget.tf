data "aws_caller_identity" "current" {}

resource "aws_budgets_budget" "monthly_account_cost" {
  account_id   = data.aws_caller_identity.current.account_id
  name         = local.monthly_budget_name
  budget_type  = "COST"
  limit_amount = var.monthly_budget_limit_usd
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  tags = {
    Name = local.monthly_budget_name
  }

  dynamic "notification" {
    for_each = toset([50, 80, 100])

    content {
      comparison_operator       = "GREATER_THAN"
      notification_type         = "ACTUAL"
      subscriber_sns_topic_arns = [aws_sns_topic.alerts.arn]
      threshold                 = notification.value
      threshold_type            = "PERCENTAGE"
    }
  }

  notification {
    comparison_operator       = "GREATER_THAN"
    notification_type         = "FORECASTED"
    subscriber_sns_topic_arns = [aws_sns_topic.alerts.arn]
    threshold                 = 100
    threshold_type            = "PERCENTAGE"
  }

  depends_on = [aws_sns_topic_policy.alerts]
}
