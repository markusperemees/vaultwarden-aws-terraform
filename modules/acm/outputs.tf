output "certificate_arn" {
  description = "ARN of the validated ACM certificate."
  value       = aws_acm_certificate_validation.this.certificate_arn
}

output "certificate_domain_name" {
  description = "Primary domain name covered by the ACM certificate."
  value       = aws_acm_certificate.this.domain_name
}

output "validation_record_fqdns" {
  description = "FQDNs of the Route53 records used for ACM DNS validation."
  value       = [for record in aws_route53_record.validation : record.fqdn]
}