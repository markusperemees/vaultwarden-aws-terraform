variable "domain_name" {
  type        = string
  description = "Fully qualified domain name for the ACM certificate."
  nullable    = false
}

variable "hosted_zone_id" {
  type        = string
  description = "ID of the Route53 hosted zone used for DNS validation."
  nullable    = false
}