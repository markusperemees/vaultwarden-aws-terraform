variable "name_prefix" {
  type        = string
  description = "Prefix used for CloudWatch alarm names."
  nullable    = false

  validation {
    condition     = trimspace(var.name_prefix) != ""
    error_message = "name_prefix must not be empty."
  }
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster."
  nullable    = false

  validation {
    condition     = trimspace(var.ecs_cluster_name) != ""
    error_message = "ecs_cluster_name must not be empty."
  }
}

variable "ecs_service_name" {
  type        = string
  description = "Name of the ECS service."
  nullable    = false

  validation {
    condition     = trimspace(var.ecs_service_name) != ""
    error_message = "ecs_service_name must not be empty."
  }
}

variable "load_balancer_arn_suffix" {
  type        = string
  description = "ARN suffix of the application load balancer."
  nullable    = false

  validation {
    condition     = trimspace(var.load_balancer_arn_suffix) != ""
    error_message = "load_balancer_arn_suffix must not be empty."
  }
}

variable "target_group_arn_suffix" {
  type        = string
  description = "ARN suffix of the ALB target group."
  nullable    = false

  validation {
    condition     = trimspace(var.target_group_arn_suffix) != ""
    error_message = "target_group_arn_suffix must not be empty."
  }
}

variable "db_instance_identifier" {
  type        = string
  description = "Identifier of the RDS instance."
  nullable    = false

  validation {
    condition     = trimspace(var.db_instance_identifier) != ""
    error_message = "db_instance_identifier must not be empty."
  }
}

variable "ecs_cpu_threshold" {
  type        = number
  description = "ECS CPU utilization alarm threshold in percent."
  default     = 80

  validation {
    condition     = var.ecs_cpu_threshold > 0 && var.ecs_cpu_threshold <= 100
    error_message = "ecs_cpu_threshold must be greater than 0 and no more than 100."
  }
}

variable "ecs_memory_threshold" {
  type        = number
  description = "ECS memory utilization alarm threshold in percent."
  default     = 80

  validation {
    condition     = var.ecs_memory_threshold > 0 && var.ecs_memory_threshold <= 100
    error_message = "ecs_memory_threshold must be greater than 0 and no more than 100."
  }
}

variable "rds_cpu_threshold" {
  type        = number
  description = "RDS CPU utilization alarm threshold in percent."
  default     = 90

  validation {
    condition     = var.rds_cpu_threshold > 0 && var.rds_cpu_threshold <= 100
    error_message = "rds_cpu_threshold must be greater than 0 and no more than 100."
  }
}

variable "rds_free_storage_threshold" {
  type        = number
  description = "RDS free storage alarm threshold in bytes."
  default     = 5368709120

  validation {
    condition     = var.rds_free_storage_threshold > 0
    error_message = "rds_free_storage_threshold must be greater than 0."
  }
}

variable "alb_unhealthy_target_threshold" {
  type        = number
  description = "Number of unhealthy ALB targets above which the alarm enters ALARM state."
  default     = 0

  validation {
    condition = (
      var.alb_unhealthy_target_threshold >= 0 &&
      floor(var.alb_unhealthy_target_threshold) == var.alb_unhealthy_target_threshold
    )
    error_message = "alb_unhealthy_target_threshold must be a non-negative integer."
  }
}

variable "utilization_period_seconds" {
  type        = number
  description = "CloudWatch period in seconds for ECS and RDS utilization alarms."
  default     = 60

  validation {
    condition = (
      var.utilization_period_seconds >= 60 &&
      var.utilization_period_seconds % 60 == 0
    )
    error_message = "utilization_period_seconds must be at least 60 seconds and a multiple of 60."
  }
}

variable "utilization_evaluation_periods" {
  type        = number
  description = "Number of periods evaluated by ECS and RDS utilization alarms."
  default     = 5

  validation {
    condition = (
      var.utilization_evaluation_periods > 0 &&
      floor(var.utilization_evaluation_periods) == var.utilization_evaluation_periods
    )
    error_message = "utilization_evaluation_periods must be a positive integer."
  }
}

variable "alb_period_seconds" {
  type        = number
  description = "CloudWatch period in seconds for the ALB unhealthy-target alarm."
  default     = 60

  validation {
    condition = (
      var.alb_period_seconds >= 60 &&
      var.alb_period_seconds % 60 == 0
    )
    error_message = "alb_period_seconds must be at least 60 seconds and a multiple of 60."
  }
}

variable "alb_evaluation_periods" {
  type        = number
  description = "Number of periods evaluated by the ALB unhealthy-target alarm."
  default     = 2

  validation {
    condition = (
      var.alb_evaluation_periods > 0 &&
      floor(var.alb_evaluation_periods) == var.alb_evaluation_periods
    )
    error_message = "alb_evaluation_periods must be a positive integer."
  }
}

variable "rds_storage_period_seconds" {
  type        = number
  description = "CloudWatch period in seconds for the RDS free-storage alarm."
  default     = 300

  validation {
    condition = (
      var.rds_storage_period_seconds >= 60 &&
      var.rds_storage_period_seconds % 60 == 0
    )
    error_message = "rds_storage_period_seconds must be at least 60 seconds and a multiple of 60."
  }
}

variable "rds_storage_evaluation_periods" {
  type        = number
  description = "Number of periods evaluated by the RDS free-storage alarm."
  default     = 1

  validation {
    condition = (
      var.rds_storage_evaluation_periods > 0 &&
      floor(var.rds_storage_evaluation_periods) == var.rds_storage_evaluation_periods
    )
    error_message = "rds_storage_evaluation_periods must be a positive integer."
  }
}

variable "treat_missing_data" {
  type        = string
  description = "How CloudWatch alarms treat missing metric data."
  default     = "notBreaching"

  validation {
    condition     = contains(["breaching", "notBreaching", "ignore", "missing"], var.treat_missing_data)
    error_message = "treat_missing_data must be one of: breaching, notBreaching, ignore, missing."
  }
}

variable "alarm_actions" {
  type        = list(string)
  description = "ARNs notified when alarms enter ALARM or return to OK state."
  default     = []

  validation {
    condition     = alltrue([for action in var.alarm_actions : trimspace(action) != ""])
    error_message = "alarm_actions must contain only non-empty ARN strings."
  }
}

variable "alb_target_5xx_threshold" {
  type        = number
  description = "Target-generated HTTP 5xx responses per period required to trigger the alarm."
  default     = 5

  validation {
    condition     = var.alb_target_5xx_threshold > 0
    error_message = "alb_target_5xx_threshold must be greater than 0."
  }
}


variable "alb_elb_5xx_threshold" {
  type        = number
  description = "ALB-generated HTTP 5xx responses per period required to trigger the alarm."
  default     = 1

  validation {
    condition     = var.alb_elb_5xx_threshold > 0
    error_message = "alb_elb_5xx_threshold must be greater than 0."
  }
}


variable "alb_latency_threshold_seconds" {
  type        = number
  description = "ALB p95 target response-time alarm threshold in seconds."
  default     = 2

  validation {
    condition     = var.alb_latency_threshold_seconds > 0
    error_message = "alb_latency_threshold_seconds must be greater than 0."
  }
}


variable "rds_freeable_memory_threshold" {
  type        = number
  description = "RDS freeable memory alarm threshold in bytes."
  default     = 104857600 # 100 MiB

  validation {
    condition     = var.rds_freeable_memory_threshold > 0
    error_message = "rds_freeable_memory_threshold must be greater than 0."
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to CloudWatch alarms."
  default     = {}
}
