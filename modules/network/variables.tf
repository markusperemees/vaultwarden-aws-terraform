variable "name_prefix" {
  type        = string
  description = "Prefix used for resource names."
  nullable    = false

  validation {
    condition     = trimspace(var.name_prefix) != ""
    error_message = "name_prefix must not be empty."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
  nullable    = false

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "subnets" {
  type = map(object({
    public_cidr = string
    app_cidr    = string
    db_cidr     = string
  }))

  description = "Public, application, and database subnet CIDRs mapped by availability zone."
  nullable    = false

  validation {
    condition     = length(var.subnets) >= 2
    error_message = "At least two availability zones are required."
  }

  validation {
    condition = alltrue(flatten([
      for subnet in values(var.subnets) : [
        can(cidrnetmask(subnet.public_cidr)),
        can(cidrnetmask(subnet.app_cidr)),
        can(cidrnetmask(subnet.db_cidr))
      ]
    ]))

    error_message = "Every subnet CIDR must be a valid IPv4 CIDR block."
  }

  validation {
    condition = length(distinct(flatten([
      for subnet in values(var.subnets) : [
        subnet.public_cidr,
        subnet.app_cidr,
        subnet.db_cidr
      ]
      ]))) == length(flatten([
      for subnet in values(var.subnets) : [
        subnet.public_cidr,
        subnet.app_cidr,
        subnet.db_cidr
      ]
    ]))

    error_message = "Every subnet CIDR must be unique."
  }
}

variable "public_subnet_map_public_ip_on_launch" {
  type        = bool
  description = "Whether EC2 instances launched in public subnets automatically receive public IPv4 addresses."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to all resources created by this module."
  default     = {}
}
