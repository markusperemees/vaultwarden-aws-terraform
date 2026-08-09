locals {
  project_name = "vaultwarden"
  environment  = "prod"
  name_prefix  = "${local.project_name}-${local.environment}"
}
