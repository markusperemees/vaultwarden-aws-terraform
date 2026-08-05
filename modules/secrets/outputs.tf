output "vaultwarden_secret_arn" {
  description = "ARN of the Vaultwarden application secret."
  value       = aws_secretsmanager_secret.vaultwarden.arn
}

output "vaultwarden_secret_name" {
  description = "Name of the Vaultwarden application secret."
  value       = aws_secretsmanager_secret.vaultwarden.name
}