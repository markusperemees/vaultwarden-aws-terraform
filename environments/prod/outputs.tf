output "route53_name_servers" {
  description = "Route53 hosted zone name servers."
  value       = module.route53.name_servers
}

output "ecr_repository_url" {
  description = "Vaultwarden ECR repository URL."
  value       = module.ecr.repository_url
}