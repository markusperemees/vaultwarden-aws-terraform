variable "domain_name" {
  type        = string
  description = "Primary fully qualified domain name for the ACM certificate."
  nullable    = false

  validation {
    condition     = trimspace(var.domain_name) != ""
    error_message = "domain_name must not be empty."
  }
}

variable "subject_alternative_names" {
  type        = list(string)
  description = "Optional additional domain names covered by the ACM certificate."
  default     = []

  validation {
    condition = (
      length(distinct(var.subject_alternative_names)) == length(var.subject_alternative_names) &&
      alltrue([for name in var.subject_alternative_names : trimspace(name) != ""])
    )
    error_message = "subject_alternative_names must contain only unique, non-empty domain names."
  }
}

variable "hosted_zone_id" {
  type        = string
  description = "ID of the Route53 hosted zone used for DNS validation."
  nullable    = false

  validation {
    condition     = trimspace(var.hosted_zone_id) != ""
    error_message = "hosted_zone_id must not be empty."
  }
}

variable "validation_record_ttl" {
  type        = number
  description = "TTL in seconds for ACM DNS validation records."
  default     = 60

  validation {
    condition = (
      var.validation_record_ttl > 0 &&
      floor(var.validation_record_ttl) == var.validation_record_ttl
    )
    error_message = "validation_record_ttl must be a positive integer."
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to the ACM certificate."
  default     = {}
}