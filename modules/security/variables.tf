variable "name_prefix" {
  type        = string
  description = "Prefix used for resource names."
  nullable    = false
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
  nullable    = false
}

variable "app_port" {
  type        = string
  description = "Port used by the Vaultwarden container."
  default     = 80
}

variable "db_port" {
  type        = number
  description = "Port used by PostgreSQL"
  default     = 5432
}