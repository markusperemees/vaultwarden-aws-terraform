variable "name_prefix" {
  type        = string
  description = "Prefix used for CloudWatch alarm names."
  nullable    = false
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster."
  nullable    = false
}

variable "ecs_service_name" {
  type        = string
  description = "Name of the ECS service."
  nullable    = false
}

variable "load_balancer_arn_suffix" {
  type        = string
  description = "ARN suffix of the application load balancer."
  nullable    = false
}

variable "target_group_arn_suffix" {
  type        = string
  description = "ARN suffix of the ALB target group."
  nullable    = false
}

variable "db_instance_identifier" {
  type        = string
  description = "Identifier of the RDS instance."
  nullable    = false
}

variable "ecs_cpu_threshold" {
  type        = number
  description = "ECS CPU utilization alarm threshold in percent."
  default     = 80
}

variable "ecs_memory_threshold" {
  type        = number
  description = "ECS memory utilization alarm threshold in percent."
  default     = 80
}

variable "rds_cpu_threshold" {
  type        = number
  description = "RDS CPU utilization alarm threshold in percent."
  default     = 80
}

variable "rds_free_storage_threshold" {
  type        = number
  description = "RDS free storage alarm threshold in bytes."
  default     = 5368709120
}

variable "alarm_actions" {
  type        = list(string)
  description = "ARNs notified when an alarm enters the ALARM state."
  default     = []
}