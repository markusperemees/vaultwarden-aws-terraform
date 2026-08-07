variable "name_prefix" {
  type        = string
  description = "Prefix used for ECS resource names."
  nullable    = false

  validation {
    condition     = trimspace(var.name_prefix) != ""
    error_message = "name_prefix must not be empty."
  }
}

variable "aws_region" {
  type        = string
  description = "AWS region used by the awslogs log driver."
  nullable    = false

  validation {
    condition     = trimspace(var.aws_region) != ""
    error_message = "aws_region must not be empty."
  }
}

variable "app_subnet_ids" {
  type        = list(string)
  description = "Private application subnet IDs used by ECS tasks."
  nullable    = false

  validation {
    condition     = length(var.app_subnet_ids) >= 2 && length(distinct(var.app_subnet_ids)) == length(var.app_subnet_ids)
    error_message = "app_subnet_ids must contain at least two unique subnet IDs for multi-AZ deployment."
  }
}

variable "security_group_id" {
  type        = string
  description = "Security group ID attached to ECS tasks."
  nullable    = false
}

variable "target_group_arn" {
  type        = string
  description = "ARN of the ALB target group."
  nullable    = false
}

variable "task_execution_role_arn" {
  type        = string
  description = "ARN of the ECS task execution role."
  nullable    = false
}

variable "task_role_arn" {
  type        = string
  description = "ARN of the ECS task role."
  nullable    = false
}

variable "repository_url" {
  type        = string
  description = "URL of the Vaultwarden ECR repository."
  nullable    = false
}

variable "image_tag" {
  type        = string
  description = "Immutable Vaultwarden image tag deployed to ECS."
  nullable    = false

  validation {
    condition     = trimspace(var.image_tag) != ""
    error_message = "image_tag must not be empty."
  }
}

variable "application_secret_arn" {
  type        = string
  description = "ARN of the Vaultwarden application secret containing ADMIN_TOKEN and DATABASE_URL."
  nullable    = false
}

variable "domain_name" {
  type        = string
  description = "Public DNS hostname used by Vaultwarden, without the URL scheme."
  nullable    = false

  validation {
    condition     = length(trimspace(var.domain_name)) > 0 && !startswith(lower(var.domain_name), "http://") && !startswith(lower(var.domain_name), "https://")
    error_message = "domain_name must be a hostname without http:// or https://."
  }
}

variable "container_port" {
  type        = number
  description = "Port exposed by the Vaultwarden container."
  default     = 80

  validation {
    condition     = var.container_port >= 1 && var.container_port <= 65535 && floor(var.container_port) == var.container_port
    error_message = "container_port must be an integer between 1 and 65535."
  }
}

variable "cpu" {
  type        = number
  description = "CPU units allocated to the Fargate task."
  default     = 256

  validation {
    condition     = contains([256, 512, 1024, 2048, 4096, 8192, 16384, 32768], var.cpu)
    error_message = "cpu must be a supported AWS Fargate task CPU value."
  }
}

variable "memory" {
  type        = number
  description = "Memory allocated to the Fargate task in MiB."
  default     = 512

  validation {
    condition     = var.memory > 0 && floor(var.memory) == var.memory
    error_message = "memory must be a positive integer in MiB."
  }
}

variable "desired_count" {
  type        = number
  description = "Desired number of ECS tasks."
  default     = 2

  validation {
    condition     = var.desired_count >= 0 && floor(var.desired_count) == var.desired_count
    error_message = "desired_count must be a non-negative integer."
  }
}

variable "log_retention_in_days" {
  type        = number
  description = "CloudWatch log retention period in days."
  default     = 30

  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180,
      365, 400, 545, 731, 1096, 1827, 2192, 2557,
      2922, 3288, 3653
    ], var.log_retention_in_days)
    error_message = "log_retention_in_days must be a CloudWatch Logs supported retention value."
  }
}

variable "efs_file_system_id" {
  type        = string
  description = "ID of the EFS file system mounted by ECS."
  nullable    = false
}

variable "efs_access_point_id" {
  type        = string
  description = "ID of the EFS access point used by ECS."
  nullable    = false
}

variable "signups_allowed" {
  type        = bool
  description = "Whether public Vaultwarden registrations are allowed."
  default     = false
}

variable "container_insights_mode" {
  type        = string
  description = "ECS Container Insights mode."
  default     = "enhanced"

  validation {
    condition     = contains(["enhanced", "enabled", "disabled"], var.container_insights_mode)
    error_message = "container_insights_mode must be enhanced, enabled, or disabled."
  }
}

variable "fargate_platform_version" {
  type        = string
  description = "Fargate platform version used by the ECS service."
  default     = "LATEST"

  validation {
    condition     = trimspace(var.fargate_platform_version) != ""
    error_message = "fargate_platform_version must not be empty."
  }
}

variable "availability_zone_rebalancing" {
  type        = bool
  description = "Whether ECS keeps service tasks balanced across Availability Zones."
  default     = true
}

variable "deployment_minimum_healthy_percent" {
  type        = number
  description = "Minimum percentage of healthy tasks maintained during a rolling deployment."
  default     = 100

  validation {
    condition     = var.deployment_minimum_healthy_percent >= 0 && var.deployment_minimum_healthy_percent <= 100 && floor(var.deployment_minimum_healthy_percent) == var.deployment_minimum_healthy_percent
    error_message = "deployment_minimum_healthy_percent must be an integer between 0 and 100."
  }
}

variable "deployment_maximum_percent" {
  type        = number
  description = "Maximum percentage of tasks allowed during a rolling deployment."
  default     = 200

  validation {
    condition     = var.deployment_maximum_percent >= 100 && floor(var.deployment_maximum_percent) == var.deployment_maximum_percent
    error_message = "deployment_maximum_percent must be an integer of at least 100."
  }
}

variable "health_check_grace_period_seconds" {
  type        = number
  description = "Seconds ECS ignores unhealthy load balancer health checks after a task starts."
  default     = 60

  validation {
    condition     = var.health_check_grace_period_seconds >= 0 && floor(var.health_check_grace_period_seconds) == var.health_check_grace_period_seconds
    error_message = "health_check_grace_period_seconds must be a non-negative integer."
  }
}

variable "deployment_circuit_breaker_enabled" {
  type        = bool
  description = "Whether the ECS deployment circuit breaker is enabled."
  default     = true
}

variable "deployment_rollback_enabled" {
  type        = bool
  description = "Whether a failed ECS deployment automatically rolls back."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to ECS resources."
  default     = {}
}