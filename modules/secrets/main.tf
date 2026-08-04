resource "aws_secretsmanager_secret" "vaultwarden" {
  name                    = "${var.name_prefix}/vaultwarden"
  description             = "Application secrets for Vaultwarden."
  recovery_window_in_days = var.recovery_window_in_days

  tags = {
    Name = "${var.name_prefix}-vaultwarden-secrets"
  }
}