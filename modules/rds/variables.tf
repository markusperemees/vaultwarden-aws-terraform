variable "name_prefix" {
  type        = string
  description = "Prefix used for resource names."
  nullable    = false

  validation {
    condition     = trimspace(var.name_prefix) != ""
    error_message = "name_prefix must not be empty."
  }
}

variable "db_subnet_ids" {
  type        = list(string)
  description = "Subnet IDs used by the RDS subnet group."
  nullable    = false

  validation {
    condition     = length(var.db_subnet_ids) >= 2 && length(distinct(var.db_subnet_ids)) == length(var.db_subnet_ids)
    error_message = "db_subnet_ids must contain at least two unique subnet IDs."
  }
}

variable "security_group_id" {
  type        = string
  description = "Security group ID attached to the RDS instance."
  nullable    = false

  validation {
    condition     = trimspace(var.security_group_id) != ""
    error_message = "security_group_id must not be empty."
  }
}

variable "database_name" {
  type        = string
  description = "Name of the Vaultwarden database."
  default     = "vaultwarden"

  validation {
    condition     = trimspace(var.database_name) != ""
    error_message = "database_name must not be empty."
  }
}

variable "database_username" {
  type        = string
  description = "Master username for PostgreSQL."
  default     = "vaultwarden"

  validation {
    condition     = trimspace(var.database_username) != ""
    error_message = "database_username must not be empty."
  }
}

variable "instance_class" {
  type        = string
  description = "RDS instance class."
  default     = "db.t4g.micro"

  validation {
    condition     = trimspace(var.instance_class) != ""
    error_message = "instance_class must not be empty."
  }
}

variable "allocated_storage" {
  type        = number
  description = "Initial database storage in GiB."
  default     = 20

  validation {
    condition     = var.allocated_storage > 0 && floor(var.allocated_storage) == var.allocated_storage
    error_message = "allocated_storage must be a positive integer."
  }
}

variable "max_allocated_storage" {
  type        = number
  description = "Maximum storage in GiB used by RDS storage autoscaling. Set to 0 to disable autoscaling."
  default     = 100

  validation {
    condition = (
      var.max_allocated_storage == 0 ||
      (
        floor(var.max_allocated_storage) == var.max_allocated_storage &&
        var.max_allocated_storage >= ceil(var.allocated_storage * 1.10)
      )
    )
    error_message = "max_allocated_storage must be 0 or an integer at least 10% greater than allocated_storage."
  }
}

variable "storage_type" {
  type        = string
  description = "Storage type used by the RDS instance."
  default     = "gp3"

  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2"], var.storage_type)
    error_message = "storage_type must be one of: gp2, gp3, io1, io2."
  }
}

variable "engine_version" {
  type        = string
  description = "PostgreSQL engine version."
  nullable    = false

  validation {
    condition     = trimspace(var.engine_version) != ""
    error_message = "engine_version must not be empty."
  }
}

variable "multi_az" {
  type        = bool
  description = "Whether to deploy the RDS instance in Multi-AZ mode."
  default     = true
}

variable "backup_retention_period" {
  type        = number
  description = "Number of days automated backups are retained."
  default     = 7

  validation {
    condition = (
      var.backup_retention_period >= 0 &&
      var.backup_retention_period <= 35 &&
      floor(var.backup_retention_period) == var.backup_retention_period
    )
    error_message = "backup_retention_period must be an integer between 0 and 35."
  }
}

variable "copy_tags_to_snapshot" {
  type        = bool
  description = "Whether RDS resource tags are copied to snapshots."
  default     = true
}

variable "deletion_protection" {
  type        = bool
  description = "Whether deletion protection is enabled for the RDS instance."
  default     = true
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Whether to skip creation of a final snapshot when the RDS instance is deleted."
  default     = false
}


variable "final_snapshot_identifier" {
  type        = string
  description = "Optional final snapshot identifier. Override this when a snapshot with the default name already exists."
  default     = null
  nullable    = true

  validation {
    condition     = var.final_snapshot_identifier == null || trimspace(var.final_snapshot_identifier) != ""
    error_message = "final_snapshot_identifier must be null or a non-empty string."
  }
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "RDS log types exported to CloudWatch Logs."
  default     = ["postgresql"]
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to RDS resources."
  default     = {}
}
