resource "aws_secretsmanager_secret" "vaultwarden" {
  name                    = "${var.name_prefix}/vaultwarden"
  description             = var.description
  recovery_window_in_days = var.recovery_window_in_days
  kms_key_id              = var.kms_key_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-vaultwarden-secrets"
  })
}
