variable "name_prefix" {
  type        = string
  description = "Prefix used for IAM role and policy names."
  nullable    = false

  validation {
    condition = (
      trimspace(var.name_prefix) != "" &&
      length(var.name_prefix) <= 40 &&
      can(regex("^[A-Za-z0-9_+=,.@-]+$", var.name_prefix))
    )
    error_message = "name_prefix must be 1-40 characters and contain only IAM-compatible characters."
  }
}

variable "secret_arns" {
  type        = list(string)
  description = "Secrets Manager secret ARNs accessible by the ECS task execution role."
  nullable    = false

  validation {
    condition = (
      length(var.secret_arns) > 0 &&
      length(distinct(var.secret_arns)) == length(var.secret_arns) &&
      alltrue([
        for arn in var.secret_arns :
        trimspace(arn) != "" && can(regex("^arn:[^:]+:secretsmanager:", arn))
      ])
    )
    error_message = "secret_arns must contain at least one unique Secrets Manager ARN."
  }
}

variable "efs_file_system_arn" {
  type        = string
  description = "ARN of the EFS file system accessible by ECS tasks."
  nullable    = false

  validation {
    condition = (
      trimspace(var.efs_file_system_arn) != "" &&
      can(regex("^arn:[^:]+:elasticfilesystem:", var.efs_file_system_arn))
    )
    error_message = "efs_file_system_arn must be a valid EFS ARN."
  }
}

variable "efs_access_point_arn" {
  type        = string
  description = "ARN of the EFS access point used by ECS tasks."
  nullable    = false

  validation {
    condition = (
      trimspace(var.efs_access_point_arn) != "" &&
      can(regex("^arn:[^:]+:elasticfilesystem:", var.efs_access_point_arn))
    )
    error_message = "efs_access_point_arn must be a valid EFS ARN."
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to IAM roles."
  default     = {}
}
