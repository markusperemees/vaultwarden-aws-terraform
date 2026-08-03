variable "ecr_repository_name" {
  type        = string
  description = "Name of the ECR repository."
  nullable    = false

  validation {
    condition     = can(regex("^[a-z0-9]+(?:[._/-][a-z0-9]+)*$", var.ecr_repository_name))
    error_message = "ECR repository name must use lowercase letters, numbers, and valid separators."
  }
}