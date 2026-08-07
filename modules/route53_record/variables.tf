variable "zone_id" {
  type        = string
  description = "ID of the Route53 hosted zone."
  nullable    = false

  validation {
    condition     = trimspace(var.zone_id) != ""
    error_message = "zone_id must not be empty."
  }
}

variable "record_name" {
  type        = string
  description = "DNS record name."
  nullable    = false

  validation {
    condition     = trimspace(var.record_name) != ""
    error_message = "record_name must not be empty."
  }
}

variable "alb_dns_name" {
  type        = string
  description = "DNS name of the ALB."
  nullable    = false

  validation {
    condition     = trimspace(var.alb_dns_name) != ""
    error_message = "alb_dns_name must not be empty."
  }
}

variable "alb_zone_id" {
  type        = string
  description = "Canonical hosted zone ID of the ALB."
  nullable    = false

  validation {
    condition     = trimspace(var.alb_zone_id) != ""
    error_message = "alb_zone_id must not be empty."
  }
}