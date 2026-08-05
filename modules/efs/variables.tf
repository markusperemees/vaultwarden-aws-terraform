variable "name_prefix" {
  type        = string
  description = "Prefix used for EFS resource names."
  nullable    = false
}

variable "subnet_ids_by_az" {
  type        = map(string)
  description = "Application subnet IDs mapped by availability zone."
  nullable    = false

  validation {
    condition     = length(var.subnet_ids_by_az) >= 2
    error_message = "At least two application subnets are required."
  }
}

variable "security_group_id" {
  type        = string
  description = "Security group ID attached to EFS mount targets."
  nullable    = false
}