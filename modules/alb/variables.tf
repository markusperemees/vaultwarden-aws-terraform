variable "name_prefix" {
  type        = string
  description = "Prefix used for resource names."
  nullable    = false

  validation {
    condition     = length(var.name_prefix) >= 1 && length(var.name_prefix) <= 28
    error_message = "name_prefix must contain between 1 and 28 characters so generated ALB names stay within AWS limits."
  }

  validation {
    condition     = can(regex("^[A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?$", var.name_prefix))
    error_message = "name_prefix may contain only letters, numbers, and hyphens, and must not begin or end with a hyphen."
  }

  validation {
    condition     = !startswith(lower(var.name_prefix), "internal-")
    error_message = "name_prefix must not begin with internal-."
  }
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC."
  nullable    = false

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "vpc_id must be a valid VPC ID."
  }
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs used by the ALB."
  nullable    = false

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "public_subnet_ids must contain at least two subnets."
  }

  validation {
    condition     = length(distinct(var.public_subnet_ids)) == length(var.public_subnet_ids)
    error_message = "public_subnet_ids must not contain duplicate subnet IDs."
  }

  validation {
    condition     = alltrue([for subnet_id in var.public_subnet_ids : can(regex("^subnet-[0-9a-f]+$", subnet_id))])
    error_message = "Every public_subnet_ids value must be a valid subnet ID."
  }
}

variable "security_group_id" {
  type        = string
  description = "Security group ID attached to the ALB."
  nullable    = false

  validation {
    condition     = can(regex("^sg-[0-9a-f]+$", var.security_group_id))
    error_message = "security_group_id must be a valid security group ID."
  }
}

variable "certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate used by the HTTPS listener."
  nullable    = false

  validation {
    condition     = can(regex("^arn:[^:]+:acm:[^:]+:[0-9]{12}:certificate/.+$", var.certificate_arn))
    error_message = "certificate_arn must be a valid ACM certificate ARN."
  }
}

variable "target_port" {
  type        = number
  description = "Port used by the Vaultwarden ECS tasks."
  default     = 80

  validation {
    condition     = var.target_port >= 1 && var.target_port <= 65535
    error_message = "target_port must be between 1 and 65535."
  }
}

variable "ssl_policy" {
  type        = string
  description = "TLS security policy used by the HTTPS listener."
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  nullable    = false

  validation {
    condition     = length(trimspace(var.ssl_policy)) > 0
    error_message = "ssl_policy must not be empty."
  }
}

variable "enable_deletion_protection" {
  type        = bool
  description = "Whether deletion protection is enabled for the ALB."
  default     = false
}

variable "deregistration_delay_seconds" {
  type        = number
  description = "Time allowed for in-flight requests before a target is deregistered."
  default     = 30

  validation {
    condition     = var.deregistration_delay_seconds >= 0 && var.deregistration_delay_seconds <= 3600
    error_message = "deregistration_delay_seconds must be between 0 and 3600."
  }
}

variable "health_check_path" {
  type        = string
  description = "Path used by the ALB target group health check."
  default     = "/alive"
  nullable    = false

  validation {
    condition     = startswith(var.health_check_path, "/")
    error_message = "health_check_path must begin with /."
  }
}

variable "health_check_matcher" {
  type        = string
  description = "HTTP status code matcher used by the target group health check."
  default     = "200"
  nullable    = false

  validation {
    condition     = length(trimspace(var.health_check_matcher)) > 0
    error_message = "health_check_matcher must not be empty."
  }
}

variable "health_check_interval_seconds" {
  type        = number
  description = "Time between target group health checks."
  default     = 30

  validation {
    condition     = var.health_check_interval_seconds >= 5 && var.health_check_interval_seconds <= 300
    error_message = "health_check_interval_seconds must be between 5 and 300."
  }
}

variable "health_check_timeout_seconds" {
  type        = number
  description = "Maximum time to wait for a health check response."
  default     = 5

  validation {
    condition     = var.health_check_timeout_seconds >= 2 && var.health_check_timeout_seconds <= 120 && var.health_check_timeout_seconds < var.health_check_interval_seconds
    error_message = "health_check_timeout_seconds must be between 2 and 120 and lower than health_check_interval_seconds."
  }
}

variable "health_check_healthy_threshold" {
  type        = number
  description = "Successful checks required before a target is considered healthy."
  default     = 2

  validation {
    condition     = var.health_check_healthy_threshold >= 2 && var.health_check_healthy_threshold <= 10
    error_message = "health_check_healthy_threshold must be between 2 and 10."
  }
}

variable "health_check_unhealthy_threshold" {
  type        = number
  description = "Failed checks required before a target is considered unhealthy."
  default     = 3

  validation {
    condition     = var.health_check_unhealthy_threshold >= 2 && var.health_check_unhealthy_threshold <= 10
    error_message = "health_check_unhealthy_threshold must be between 2 and 10."
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to ALB resources."
  default     = {}
  nullable    = false
}
