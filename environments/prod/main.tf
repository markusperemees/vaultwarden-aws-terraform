module "network" {
  source = "../../modules/network"

  name_prefix = "${local.project_name}-${local.environment}"
  vpc_cidr    = var.vpc_cidr
  subnets     = var.subnets
}

module "ecr" {
  source = "../../modules/ecr"

  ecr_repository_name = "${local.project_name}-${local.environment}"
}

module "security" {
  source = "../../modules/security"

  name_prefix = "${local.project_name}-${local.environment}"
  vpc_id      = module.network.vpc_id
}