variable "name_prefix" {
  type        = string
  description = "Prefix used for resource names."
  nullable    = false

  validation {
    condition     = trimspace(var.name_prefix) != ""
    error_message = "name_prefix must not be empty."
  }
}

variable "description" {
  type        = string
  description = "Description of the Vaultwarden application secret."
  default     = "Application secrets for Vaultwarden."

  validation {
    condition     = trimspace(var.description) != ""
    error_message = "description must not be empty."
  }
}

variable "recovery_window_in_days" {
  type        = number
  description = "Number of days before a deleted secret is permanently removed."
  default     = 7

  validation {
    condition = (
      var.recovery_window_in_days >= 7 &&
      var.recovery_window_in_days <= 30 &&
      floor(var.recovery_window_in_days) == var.recovery_window_in_days
    )
    error_message = "recovery_window_in_days must be an integer between 7 and 30."
  }
}

variable "kms_key_id" {
  type        = string
  description = "Optional KMS key ARN or ID used to encrypt secret values. If null, Secrets Manager uses the AWS managed aws/secretsmanager key."
  default     = null
  nullable    = true

  validation {
    condition     = var.kms_key_id == null || trimspace(var.kms_key_id) != ""
    error_message = "kms_key_id must be null or a non-empty string."
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to the Secrets Manager secret."
  default     = {}
}