variable "name_prefix" {
  type        = string
  description = "Prefix used for EFS resource names."
  nullable    = false

  validation {
    condition     = trimspace(var.name_prefix) != ""
    error_message = "name_prefix must not be empty."
  }
}

variable "subnet_ids_by_az" {
  type        = map(string)
  description = "Application subnet IDs mapped by availability zone."
  nullable    = false

  validation {
    condition = (
      length(var.subnet_ids_by_az) >= 2 &&
      length(distinct(values(var.subnet_ids_by_az))) == length(var.subnet_ids_by_az) &&
      alltrue([for az, subnet_id in var.subnet_ids_by_az : trimspace(az) != "" && trimspace(subnet_id) != ""])
    )
    error_message = "subnet_ids_by_az must contain at least two unique, non-empty subnet IDs mapped to non-empty availability zone names."
  }
}

variable "security_group_id" {
  type        = string
  description = "Security group ID attached to EFS mount targets."
  nullable    = false

  validation {
    condition     = trimspace(var.security_group_id) != ""
    error_message = "security_group_id must not be empty."
  }
}

variable "transition_to_ia" {
  type        = string
  description = "Time since last access before files transition to the EFS Infrequent Access storage class."
  default     = "AFTER_30_DAYS"

  validation {
    condition = contains([
      "AFTER_1_DAY",
      "AFTER_7_DAYS",
      "AFTER_14_DAYS",
      "AFTER_30_DAYS",
      "AFTER_60_DAYS",
      "AFTER_90_DAYS",
      "AFTER_180_DAYS",
      "AFTER_270_DAYS",
      "AFTER_365_DAYS"
    ], var.transition_to_ia)
    error_message = "transition_to_ia must be a supported EFS lifecycle value."
  }
}

variable "access_point_path" {
  type        = string
  description = "Root directory path exposed through the EFS access point."
  default     = "/vaultwarden"

  validation {
    condition     = startswith(var.access_point_path, "/") && trimspace(var.access_point_path) != "/"
    error_message = "access_point_path must be a non-root absolute path beginning with '/'."
  }
}

variable "access_point_uid" {
  type        = number
  description = "POSIX user ID enforced by the EFS access point."
  default     = 1000

  validation {
    condition     = var.access_point_uid >= 0 && floor(var.access_point_uid) == var.access_point_uid
    error_message = "access_point_uid must be a non-negative integer."
  }
}

variable "access_point_gid" {
  type        = number
  description = "POSIX group ID enforced by the EFS access point."
  default     = 1000

  validation {
    condition     = var.access_point_gid >= 0 && floor(var.access_point_gid) == var.access_point_gid
    error_message = "access_point_gid must be a non-negative integer."
  }
}

variable "access_point_permissions" {
  type        = string
  description = "POSIX permissions used when the EFS access point root directory is created."
  default     = "0750"

  validation {
    condition     = can(regex("^0?[0-7]{3}$", var.access_point_permissions))
    error_message = "access_point_permissions must be a valid three- or four-digit octal permission string, for example '750' or '0750'."
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to EFS resources."
  default     = {}
}