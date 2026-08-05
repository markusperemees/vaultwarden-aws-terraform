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

  efs_file_system_arn  = module.efs.file_system_arn
  efs_access_point_arn = module.efs.access_point_arn
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

module "efs" {
  source = "../../modules/efs"

  name_prefix       = "${local.project_name}-${local.environment}"
  subnet_ids_by_az  = module.network.app_subnet_ids_by_az
  security_group_id = module.security.efs_security_group_id
}

module "ecs" {
  source = "../../modules/ecs"

  name_prefix = "${local.project_name}-${local.environment}"
  aws_region  = var.aws_region

  app_subnet_ids    = values(module.network.app_subnet_ids_by_az)
  security_group_id = module.security.ecs_security_group_id
  target_group_arn  = module.alb.target_group_arn

  task_execution_role_arn = module.iam.task_execution_role_arn
  task_role_arn           = module.iam.task_role_arn

  repository_url = module.ecr.repository_url
  image_tag      = var.vaultwarden_image_tag

  application_secret_arn = module.secrets.vaultwarden_secret_arn
  domain_name            = var.vaultwarden_domain_name

  efs_file_system_id  = module.efs.file_system_id
  efs_access_point_id = module.efs.access_point_id
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"

  name_prefix = "${local.project_name}-${local.environment}"

  ecs_cluster_name = module.ecs.cluster_name
  ecs_service_name = module.ecs.service_name

  load_balancer_arn_suffix = module.alb.load_balancer_arn_suffix
  target_group_arn_suffix  = module.alb.target_group_arn_suffix

  db_instance_identifier = module.rds.db_instance_identifier
}