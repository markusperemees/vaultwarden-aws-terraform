variable "name_prefix" {
  type        = string
  description = "Prefix used for resource names."
  nullable    = false

  validation {
    condition     = trimspace(var.name_prefix) != ""
    error_message = "name_prefix must not be empty."
  }
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC in which the security groups are created."
  nullable    = false

  validation {
    condition     = trimspace(var.vpc_id) != ""
    error_message = "vpc_id must not be empty."
  }
}

variable "app_port" {
  type        = number
  description = "TCP port exposed by the application container."
  default     = 80

  validation {
    condition     = var.app_port >= 1 && var.app_port <= 65535 && floor(var.app_port) == var.app_port
    error_message = "app_port must be an integer between 1 and 65535."
  }
}

variable "db_port" {
  type        = number
  description = "TCP port used by PostgreSQL."
  default     = 5432

  validation {
    condition     = var.db_port >= 1 && var.db_port <= 65535 && floor(var.db_port) == var.db_port
    error_message = "db_port must be an integer between 1 and 65535."
  }
}

variable "alb_ingress_ipv4_cidr" {
  type        = string
  description = "IPv4 CIDR allowed to access the public ALB on HTTP and HTTPS."
  default     = "0.0.0.0/0"
  nullable    = false

  validation {
    condition     = can(cidrnetmask(var.alb_ingress_ipv4_cidr))
    error_message = "alb_ingress_ipv4_cidr must be a valid IPv4 CIDR block."
  }
}

variable "ecs_egress_ipv4_cidr" {
  type        = string
  description = "IPv4 CIDR allowed for outbound traffic from ECS tasks."
  default     = "0.0.0.0/0"
  nullable    = false

  validation {
    condition     = can(cidrnetmask(var.ecs_egress_ipv4_cidr))
    error_message = "ecs_egress_ipv4_cidr must be a valid IPv4 CIDR block."
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to security groups."
  default     = {}
  nullable    = false
}
