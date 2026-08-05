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

module "rds" {
  source = "../../modules/rds"

  name_prefix       = "${local.project_name}-${local.environment}"
  db_subnet_ids     = values(module.network.db_subnet_ids_by_az)
  security_group_id = module.security.rds_security_group_id

  engine_version = var.db_engine_version
}

module "secrets" {
  source = "../../modules/secrets"

  name_prefix = "${local.project_name}-${local.environment}"
}

module "iam" {
  source = "../../modules/iam"

  name_prefix = "${local.project_name}-${local.environment}"

  secret_arns = [
    module.secrets.vaultwarden_secret_arn,
    module.rds.master_user_secret_arn
  ]
}

module "route53" {
  source = "../../modules/route53"

  domain_name = var.domain_name
}

module "acm" {
  source = "../../modules/acm"

  domain_name    = var.vaultwarden_domain_name
  hosted_zone_id = module.route53.zone_id
}

module "alb" {
  source = "../../modules/alb"

  name_prefix       = "${local.project_name}-${local.environment}"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = values(module.network.public_subnet_ids_by_az)
  security_group_id = module.security.alb_security_group_id
  certificate_arn   = module.acm.certificate_arn
}

module "route53_record" {
  source = "../../modules/route53_record"

  zone_id      = module.route53.zone_id
  record_name  = var.vaultwarden_domain_name
  alb_dns_name = module.alb.load_balancer_dns_name
  alb_zone_id  = module.alb.load_balancer_zone_id
}