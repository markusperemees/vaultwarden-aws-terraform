variable "domain_name" {
  type        = string
  description = "Root domain name managed in Route53."
  nullable    = false

  validation {
    condition     = can(regex("^[a-z0-9.-]+\\.[a-z]{2,}$", var.domain_name))
    error_message = "domain_name must be a valid lowercase domain name."
  }
}