output "route53_name_servers" {
  description = "Route53 hosted zone name servers."
  value       = module.route53.name_servers
}

output "ecr_repository_url" {
  description = "Vaultwarden ECR repository URL."
  value       = module.ecr.repository_url
}

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint."
  value       = module.rds.db_endpoint
}

output "rds_master_secret_arn" {
  description = "ARN of the RDS-managed master secret."
  value       = module.rds.master_user_secret_arn
}

output "vaultwarden_secret_arn" {
  description = "ARN of the Vaultwarden application secret."
  value       = module.secrets.vaultwarden_secret_arn
}