variable "name_prefix" {
  type        = string
  description = "Prefix used for resource names."
  nullable    = false
}

variable "recovery_window_in_days" {
  type        = number
  description = "Number of days before a deleted secret is permanently removed."
  default     = 7

  validation {
    condition     = var.recovery_window_in_days >= 7 && var.recovery_window_in_days <= 30
    error_message = "Recovery window must be between 7 and 30 days."
  }
}