variable "name_prefix" {
  type        = string
  description = "Prefix used for resource names."
  nullable    = false
}

variable "db_subnet_ids" {
  type        = list(string)
  description = "Subnet IDs used by the RDS subnet group."
  nullable    = false
}

variable "security_group_id" {
  type        = string
  description = "Security group ID attached to the RDS instance."
  nullable    = false
}

variable "database_name" {
  type        = string
  description = "Name of the Vaultwarden database."
  default     = "vaultwarden"
}

variable "database_username" {
  type        = string
  description = "Master username for PostgreSQL."
  default     = "vaultwarden"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class."
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  type        = number
  description = "Allocated database storage in GB."
  default     = 20
}

variable "engine_version" {
  type        = string
  description = "PostgreSQL engine version."
}