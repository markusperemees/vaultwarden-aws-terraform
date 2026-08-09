variable "aws_region" {
  type        = string
  description = "AWS region where bootstrap resources are created."
  nullable    = false

  validation {
    condition     = contains(["eu-north-1", "eu-west-1"], var.aws_region)
    error_message = "AWS region must be eu-north-1 or eu-west-1."
  }
}

variable "state_bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name for Terraform state."
  nullable    = false

  validation {
    condition = (
      can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.state_bucket_name)) &&
      !startswith(var.state_bucket_name, "xn--") &&
      !startswith(var.state_bucket_name, "sthree-") &&
      !startswith(var.state_bucket_name, "amzn-s3-demo-") &&
      !endswith(var.state_bucket_name, "-s3alias") &&
      !endswith(var.state_bucket_name, "--ol-s3") &&
      !endswith(var.state_bucket_name, "--x-s3") &&
      !endswith(var.state_bucket_name, "--table-s3")
    )

    error_message = "The S3 bucket name is invalid."
  }
}

variable "state_noncurrent_version_expiration_days" {
  type        = number
  description = "Days before eligible noncurrent Terraform state versions expire."
  default     = 180

  validation {
    condition = (
      var.state_noncurrent_version_expiration_days > 0 &&
      floor(var.state_noncurrent_version_expiration_days) == var.state_noncurrent_version_expiration_days
    )
    error_message = "state_noncurrent_version_expiration_days must be a positive integer."
  }
}

variable "state_noncurrent_versions_to_retain" {
  type        = number
  description = "Minimum number of newer noncurrent Terraform state versions retained."
  default     = 30

  validation {
    condition = (
      var.state_noncurrent_versions_to_retain >= 1 &&
      var.state_noncurrent_versions_to_retain <= 100 &&
      floor(var.state_noncurrent_versions_to_retain) == var.state_noncurrent_versions_to_retain
    )
    error_message = "state_noncurrent_versions_to_retain must be an integer between 1 and 100."
  }
}

variable "state_abort_incomplete_multipart_upload_days" {
  type        = number
  description = "Days before incomplete state bucket multipart uploads are aborted."
  default     = 7

  validation {
    condition = (
      var.state_abort_incomplete_multipart_upload_days > 0 &&
      floor(var.state_abort_incomplete_multipart_upload_days) == var.state_abort_incomplete_multipart_upload_days
    )
    error_message = "state_abort_incomplete_multipart_upload_days must be a positive integer."
  }
}

variable "github_owner_id" {
  type        = string
  description = "Immutable numeric ID of the GitHub repository owner."
  nullable    = false

  validation {
    condition     = can(regex("^[0-9]+$", var.github_owner_id))
    error_message = "github_owner_id must contain only digits."
  }
}

variable "github_owner" {
  type        = string
  description = "Login name of the GitHub repository owner."
  nullable    = false

  validation {
    condition     = trimspace(var.github_owner) != ""
    error_message = "github_owner must not be empty."
  }
}

variable "github_repository_id" {
  type        = string
  description = "Immutable numeric ID of the GitHub repository."
  nullable    = false

  validation {
    condition     = can(regex("^[0-9]+$", var.github_repository_id))
    error_message = "github_repository_id must contain only digits."
  }
}

variable "github_repository" {
  type        = string
  description = "GitHub repository name."
  nullable    = false

  validation {
    condition     = trimspace(var.github_repository) != ""
    error_message = "github_repository must not be empty."
  }
}
