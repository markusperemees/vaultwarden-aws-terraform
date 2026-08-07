variable "domain_name" {
  type        = string
  description = "Root domain name managed in the public Route53 hosted zone."
  nullable    = false

  validation {
    condition = (
      length(var.domain_name) <= 253 &&
      can(regex(
        "^([a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\\.)+[a-z]{2,63}$",
        var.domain_name
      ))
    )
    error_message = "domain_name must be a valid lowercase domain name without a trailing dot."
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to the Route53 hosted zone."
  default     = {}
}