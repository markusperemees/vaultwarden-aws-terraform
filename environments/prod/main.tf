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