variable "ecr_repository_name" {
  type        = string
  description = "Name of the ECR repository."
  nullable    = false

  validation {
    condition = (
      length(var.ecr_repository_name) >= 2 &&
      length(var.ecr_repository_name) <= 256 &&
      can(regex(
        "^[a-z0-9]+((\\.|_|__|-+)[a-z0-9]+)*(\\/[a-z0-9]+((\\.|_|__|-+)[a-z0-9]+)*)*$",
        var.ecr_repository_name
      ))
    )
    error_message = "ecr_repository_name must be 2-256 characters and use a valid Amazon ECR repository name format."
  }
}

variable "image_tag_mutability" {
  type        = string
  description = "Whether image tags can be overwritten."
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  type        = bool
  description = "Whether ECR performs a basic vulnerability scan when an image is pushed."
  default     = true
}

variable "encryption_type" {
  type        = string
  description = "Encryption type used for ECR images at rest."
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "encryption_type must be AES256 or KMS."
  }
}

variable "kms_key_arn" {
  type        = string
  description = "Optional KMS key ARN or ID used when encryption_type is KMS. If null, the AWS managed ECR KMS key is used."
  default     = null
  nullable    = true

  validation {
    condition     = var.kms_key_arn == null || trimspace(var.kms_key_arn) != ""
    error_message = "kms_key_arn must be null or a non-empty string."
  }
}

variable "untagged_image_retention_days" {
  type        = number
  description = "Number of days to retain untagged images before expiration."
  default     = 1

  validation {
    condition = (
      var.untagged_image_retention_days > 0 &&
      floor(var.untagged_image_retention_days) == var.untagged_image_retention_days
    )
    error_message = "untagged_image_retention_days must be a positive integer."
  }
}

variable "tagged_image_retention_count" {
  type        = number
  description = "Maximum number of tagged images retained by the lifecycle policy."
  default     = 10

  validation {
    condition = (
      var.tagged_image_retention_count > 0 &&
      floor(var.tagged_image_retention_count) == var.tagged_image_retention_count
    )
    error_message = "tagged_image_retention_count must be a positive integer."
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to the ECR repository."
  default     = {}
}
