variable "name_prefix" {
  type        = string
  description = "Prefix used for resource names."
  nullable    = false
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC."
  nullable    = false
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs used by the ALB."
  nullable    = false
}

variable "security_group_id" {
  type        = string
  description = "Security group ID attached to the ALB."
  nullable    = false
}

variable "certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate used by the HTTPS listener."
  nullable    = false
}

variable "target_port" {
  type        = number
  description = "Port used by the Vaultwarden ECS tasks."
  default     = 80
}

variable "health_check_path" {
  type        = string
  description = "Path used by the ALB target group health check."
  default     = "/alive"
}