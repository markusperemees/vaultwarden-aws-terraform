variable "name_prefix" {
  type        = string
  description = "Prefix used for resource names."
  nullable    = false
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

  description = "Subnet CIDR blocks grouped by availability zone."
  nullable    = false

  validation {
    condition = (
      length(var.subnets) == 2 &&
      alltrue(flatten([
        for subnet in values(var.subnets) : [
          can(cidrnetmask(subnet.public_cidr)),
          can(cidrnetmask(subnet.app_cidr)),
          can(cidrnetmask(subnet.db_cidr))
        ]
      ])) &&
      length(distinct(flatten([
        for subnet in values(var.subnets) : [
          subnet.public_cidr,
          subnet.app_cidr,
          subnet.db_cidr
        ]
      ]))) == 6
    )

    error_message = "Exactly two availability zones with six unique valid IPv4 subnet CIDRs are required."
  }
}