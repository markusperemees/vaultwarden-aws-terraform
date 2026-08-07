output "zone_id" {
  description = "ID of the Route53 hosted zone."
  value       = aws_route53_zone.this.zone_id
}

output "zone_arn" {
  description = "ARN of the Route53 hosted zone."
  value       = aws_route53_zone.this.arn
}

output "domain_name" {
  description = "Domain name managed by the Route53 hosted zone."
  value       = aws_route53_zone.this.name
}

output "name_servers" {
  description = "Name servers assigned to the Route53 hosted zone."
  value       = aws_route53_zone.this.name_servers
}