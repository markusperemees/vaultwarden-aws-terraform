variable "aws_region" {
  type        = string
  description = "AWS region where production resources are created."
  nullable    = false

  validation {
    condition     = contains(["eu-north-1", "eu-west-1"], var.aws_region)
    error_message = "AWS region must be eu-north-1 or eu-west-1."
  }
}

variable "vpc_cidr" {
  type = string
}

variable "subnets" {
  type = map(object({
    public_cidr = string
    app_cidr    = string
    db_cidr     = string
  }))
}

variable "db_engine_version" {
  type        = string
  description = "PostgreSQL engine version."
  nullable    = false
}

variable "domain_name" {
  type        = string
  description = "Root domain name managed in Route53."
  nullable    = false
}