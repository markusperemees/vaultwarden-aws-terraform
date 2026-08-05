variable "name_prefix" {
  type        = string
  description = "Prefix used for IAM role names."
  nullable    = false
}

variable "secret_arns" {
  type        = list(string)
  description = "Secrets Manager secret ARNs accessible by the ECS task execution role."
  nullable    = false

  validation {
    condition     = length(var.secret_arns) > 0
    error_message = "At least one secret ARN must be provided."
  }
}

variable "efs_file_system_arn" {
  type        = string
  description = "ARN of the EFS file system accessible by ECS tasks."
  nullable    = false
}

variable "efs_access_point_arn" {
  type        = string
  description = "ARN of the EFS access point used by ECS tasks."
  nullable    = false
}