variable "zone_id" {
  type        = string
  description = "ID of the Route53 hosted zone."
}

variable "record_name" {
  type        = string
  description = "DNS record name."
}

variable "alb_dns_name" {
  type        = string
  description = "DNS name of the ALB."
}

variable "alb_zone_id" {
  type        = string
  description = "Canonical hosted zone ID of the ALB."
}