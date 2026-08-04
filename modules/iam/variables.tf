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