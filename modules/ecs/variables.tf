variable "name_prefix" {
  type        = string
  description = "Prefix used for ECS resource names."
  nullable    = false
}

variable "aws_region" {
  type        = string
  description = "AWS region used by ECS and CloudWatch Logs."
  nullable    = false
}

variable "app_subnet_ids" {
  type        = list(string)
  description = "Private application subnet IDs used by ECS tasks."
  nullable    = false
}

variable "security_group_id" {
  type        = string
  description = "Security group ID attached to ECS tasks."
  nullable    = false
}

variable "target_group_arn" {
  type        = string
  description = "ARN of the ALB target group."
  nullable    = false
}

variable "task_execution_role_arn" {
  type        = string
  description = "ARN of the ECS task execution role."
  nullable    = false
}

variable "task_role_arn" {
  type        = string
  description = "ARN of the ECS task role."
  nullable    = false
}

variable "repository_url" {
  type        = string
  description = "URL of the Vaultwarden ECR repository."
  nullable    = false
}

variable "image_tag" {
  type        = string
  description = "Immutable Vaultwarden image tag deployed to ECS."
  nullable    = false
}

variable "application_secret_arn" {
  type        = string
  description = "ARN of the Vaultwarden application secret."
  nullable    = false
}

variable "domain_name" {
  type        = string
  description = "Public HTTPS URL used by Vaultwarden."
  nullable    = false
}

variable "container_port" {
  type        = number
  description = "Port exposed by the Vaultwarden container."
  default     = 80
}

variable "cpu" {
  type        = number
  description = "CPU units allocated to the Fargate task."
  default     = 256
}

variable "memory" {
  type        = number
  description = "Memory allocated to the Fargate task in MiB."
  default     = 512
}

variable "desired_count" {
  type        = number
  description = "Desired number of ECS tasks."
  default     = 2
}

variable "log_retention_in_days" {
  type        = number
  description = "CloudWatch log retention period."
  default     = 30
}

variable "efs_file_system_id" {
  type        = string
  description = "ID of the EFS file system mounted by ECS."
  nullable    = false
}

variable "efs_access_point_id" {
  type        = string
  description = "ID of the EFS access point used by ECS."
  nullable    = false
}