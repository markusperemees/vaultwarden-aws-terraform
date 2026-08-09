# General

variable "aws_region" {
  type        = string
  description = "AWS region where production resources are created."
  nullable    = false

  validation {
    condition     = contains(["eu-north-1", "eu-west-1"], var.aws_region)
    error_message = "AWS region must be eu-north-1 or eu-west-1."
  }
}

# Network

variable "vpc_cidr" {
  type        = string
  description = "CIDR block used by the production VPC."
  nullable    = false

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "subnets" {
  type = map(object({
    public_cidr = string
    app_cidr    = string
    db_cidr     = string
  }))

  description = "Public, application, and database subnet CIDRs mapped by availability zone."
  nullable    = false

  validation {
    condition     = length(var.subnets) >= 2
    error_message = "At least two availability zones are required."
  }

  validation {
    condition = alltrue(flatten([
      for subnet in values(var.subnets) : [
        can(cidrnetmask(subnet.public_cidr)),
        can(cidrnetmask(subnet.app_cidr)),
        can(cidrnetmask(subnet.db_cidr))
      ]
    ]))
    error_message = "Every subnet CIDR must be a valid IPv4 CIDR block."
  }

  validation {
    condition = length(distinct(flatten([
      for subnet in values(var.subnets) : [
        subnet.public_cidr,
        subnet.app_cidr,
        subnet.db_cidr
      ]
      ]))) == length(flatten([
      for subnet in values(var.subnets) : [
        subnet.public_cidr,
        subnet.app_cidr,
        subnet.db_cidr
      ]
    ]))
    error_message = "Every subnet CIDR must be unique."
  }
}

# RDS

variable "db_engine_version" {
  type        = string
  description = "PostgreSQL engine version."
  nullable    = false
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class used by the Vaultwarden database."
  nullable    = false

  validation {
    condition     = trimspace(var.db_instance_class) != ""
    error_message = "db_instance_class must not be empty."
  }
}

variable "db_allocated_storage" {
  type        = number
  description = "Initial RDS storage in GiB."
  nullable    = false

  validation {
    condition     = var.db_allocated_storage > 0 && floor(var.db_allocated_storage) == var.db_allocated_storage
    error_message = "db_allocated_storage must be a positive integer."
  }
}

variable "db_max_allocated_storage" {
  type        = number
  description = "Maximum RDS storage in GiB. Set to 0 to disable storage autoscaling."
  nullable    = false

  validation {
    condition = (
      var.db_max_allocated_storage == 0 ||
      (
        floor(var.db_max_allocated_storage) == var.db_max_allocated_storage &&
        var.db_max_allocated_storage >= ceil(var.db_allocated_storage * 1.10)
      )
    )
    error_message = "db_max_allocated_storage must be 0 or an integer at least 10% greater than db_allocated_storage."
  }
}

variable "db_multi_az" {
  type        = bool
  description = "Whether the RDS instance is deployed in Multi-AZ mode."
  nullable    = false
}

variable "db_backup_retention_period" {
  type        = number
  description = "Number of days automated RDS backups are retained."
  nullable    = false

  validation {
    condition = (
      var.db_backup_retention_period >= 0 &&
      var.db_backup_retention_period <= 35 &&
      floor(var.db_backup_retention_period) == var.db_backup_retention_period
    )
    error_message = "db_backup_retention_period must be an integer between 0 and 35."
  }
}

variable "db_deletion_protection" {
  type        = bool
  description = "Whether deletion protection is enabled for the RDS instance."
  nullable    = false
}

variable "db_skip_final_snapshot" {
  type        = bool
  description = "Whether to skip the final snapshot when the RDS instance is deleted."
  nullable    = false
}

variable "db_final_snapshot_identifier" {
  type        = string
  description = "Optional identifier for the final RDS snapshot."
  default     = null
  nullable    = true

  validation {
    condition     = var.db_final_snapshot_identifier == null || trimspace(var.db_final_snapshot_identifier) != ""
    error_message = "db_final_snapshot_identifier must be null or a non-empty string."
  }
}

# DNS and Vaultwarden

variable "domain_name" {
  type        = string
  description = "Root domain name managed in Route53."
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

variable "vaultwarden_domain_name" {
  type        = string
  description = "Fully qualified domain name used by Vaultwarden."
  nullable    = false

  validation {
    condition = (
      length(var.vaultwarden_domain_name) <= 253 &&
      can(regex(
        "^([a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\\.)+[a-z]{2,63}$",
        var.vaultwarden_domain_name
      )) &&
      var.vaultwarden_domain_name != var.domain_name &&
      endswith(var.vaultwarden_domain_name, ".${var.domain_name}")
    )
    error_message = "vaultwarden_domain_name must be a valid lowercase subdomain of domain_name."
  }
}

variable "vaultwarden_image_tag" {
  type        = string
  description = "Immutable Vaultwarden image tag deployed to ECS."
  nullable    = false

  validation {
    condition = (
      length(var.vaultwarden_image_tag) <= 128 &&
      can(regex("^[A-Za-z0-9_][A-Za-z0-9_.-]{0,127}$", var.vaultwarden_image_tag)) &&
      lower(var.vaultwarden_image_tag) != "latest"
    )
    error_message = "vaultwarden_image_tag must be a valid immutable container tag and must not be latest."
  }
}

variable "vaultwarden_port" {
  type        = number
  description = "Port exposed by the Vaultwarden container."
  nullable    = false

  validation {
    condition = (
      var.vaultwarden_port >= 1 &&
      var.vaultwarden_port <= 65535 &&
      floor(var.vaultwarden_port) == var.vaultwarden_port
    )
    error_message = "vaultwarden_port must be an integer between 1 and 65535."
  }
}

# ECS

variable "ecs_desired_count" {
  type        = number
  description = "Desired number of Vaultwarden ECS tasks."
  nullable    = false

  validation {
    condition     = var.ecs_desired_count >= 0 && floor(var.ecs_desired_count) == var.ecs_desired_count
    error_message = "ecs_desired_count must be a non-negative integer."
  }
}

variable "ecs_cpu" {
  type        = number
  description = "CPU units allocated to the Vaultwarden Fargate task."
  nullable    = false

  validation {
    condition     = contains([256, 512, 1024, 2048, 4096, 8192, 16384, 32768], var.ecs_cpu)
    error_message = "ecs_cpu must be a supported AWS Fargate task CPU value."
  }
}

variable "ecs_memory" {
  type        = number
  description = "Memory allocated to the Vaultwarden Fargate task in MiB."
  nullable    = false

  validation {
    condition     = var.ecs_memory > 0 && floor(var.ecs_memory) == var.ecs_memory
    error_message = "ecs_memory must be a positive integer in MiB."
  }
}

variable "ecs_log_retention_in_days" {
  type        = number
  description = "CloudWatch log retention period for Vaultwarden ECS logs."
  nullable    = false

  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180,
      365, 400, 545, 731, 1096, 1827, 2192, 2557,
      2922, 3288, 3653
    ], var.ecs_log_retention_in_days)
    error_message = "ecs_log_retention_in_days must be a supported CloudWatch Logs retention value."
  }
}

variable "vaultwarden_signups_allowed" {
  type        = bool
  description = "Whether public Vaultwarden registrations are allowed."
  nullable    = false
}

# ALB

variable "alb_enable_deletion_protection" {
  type        = bool
  description = "Whether deletion protection is enabled for the production ALB."
  nullable    = false
}

# ECR

variable "ecr_untagged_image_retention_days" {
  type        = number
  description = "Number of days untagged ECR images are retained."
  nullable    = false

  validation {
    condition     = var.ecr_untagged_image_retention_days > 0 && floor(var.ecr_untagged_image_retention_days) == var.ecr_untagged_image_retention_days
    error_message = "ecr_untagged_image_retention_days must be a positive integer."
  }
}

variable "ecr_tagged_image_retention_count" {
  type        = number
  description = "Maximum number of tagged ECR images retained."
  nullable    = false

  validation {
    condition     = var.ecr_tagged_image_retention_count > 0 && floor(var.ecr_tagged_image_retention_count) == var.ecr_tagged_image_retention_count
    error_message = "ecr_tagged_image_retention_count must be a positive integer."
  }
}

# Secrets Manager

variable "vaultwarden_secret_recovery_window_in_days" {
  type        = number
  description = "Number of days before a deleted Vaultwarden secret is permanently removed."
  nullable    = false

  validation {
    condition = (
      var.vaultwarden_secret_recovery_window_in_days >= 7 &&
      var.vaultwarden_secret_recovery_window_in_days <= 30 &&
      floor(var.vaultwarden_secret_recovery_window_in_days) == var.vaultwarden_secret_recovery_window_in_days
    )
    error_message = "vaultwarden_secret_recovery_window_in_days must be an integer between 7 and 30."
  }
}

# CloudWatch

variable "cloudwatch_ecs_cpu_threshold" {
  type        = number
  description = "ECS CPU utilization alarm threshold in percent."
  nullable    = false

  validation {
    condition     = var.cloudwatch_ecs_cpu_threshold > 0 && var.cloudwatch_ecs_cpu_threshold <= 100
    error_message = "cloudwatch_ecs_cpu_threshold must be greater than 0 and no more than 100."
  }
}

variable "cloudwatch_ecs_memory_threshold" {
  type        = number
  description = "ECS memory utilization alarm threshold in percent."
  nullable    = false

  validation {
    condition     = var.cloudwatch_ecs_memory_threshold > 0 && var.cloudwatch_ecs_memory_threshold <= 100
    error_message = "cloudwatch_ecs_memory_threshold must be greater than 0 and no more than 100."
  }
}

variable "cloudwatch_rds_cpu_threshold" {
  type        = number
  description = "RDS CPU utilization alarm threshold in percent."
  nullable    = false

  validation {
    condition     = var.cloudwatch_rds_cpu_threshold > 0 && var.cloudwatch_rds_cpu_threshold <= 100
    error_message = "cloudwatch_rds_cpu_threshold must be greater than 0 and no more than 100."
  }
}

variable "cloudwatch_rds_free_storage_threshold_bytes" {
  type        = number
  description = "RDS free storage alarm threshold in bytes."
  nullable    = false

  validation {
    condition     = var.cloudwatch_rds_free_storage_threshold_bytes > 0
    error_message = "cloudwatch_rds_free_storage_threshold_bytes must be greater than 0."
  }
}

variable "cloudwatch_alb_unhealthy_target_threshold" {
  type        = number
  description = "Number of unhealthy ALB targets above which the alarm enters ALARM state."
  nullable    = false

  validation {
    condition = (
      var.cloudwatch_alb_unhealthy_target_threshold >= 0 &&
      floor(var.cloudwatch_alb_unhealthy_target_threshold) == var.cloudwatch_alb_unhealthy_target_threshold
    )
    error_message = "cloudwatch_alb_unhealthy_target_threshold must be a non-negative integer."
  }
}

variable "cloudwatch_alarm_actions" {
  type        = list(string)
  description = "ARNs notified when CloudWatch alarms enter ALARM or return to OK state."
  nullable    = false

  validation {
    condition = alltrue([
      for action in var.cloudwatch_alarm_actions :
      trimspace(action) != "" && can(regex("^arn:[^:]+:", action))
    ])
    error_message = "cloudwatch_alarm_actions must contain only valid, non-empty ARN strings."
  }
}
