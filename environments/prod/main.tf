module "network" {
  source = "../../modules/network"

  name_prefix = local.name_prefix
  vpc_cidr    = var.vpc_cidr
  subnets     = var.subnets
}

module "ecr" {
  source = "../../modules/ecr"

  ecr_repository_name           = local.name_prefix
  untagged_image_retention_days = var.ecr_untagged_image_retention_days
  tagged_image_retention_count  = var.ecr_tagged_image_retention_count
}

module "security" {
  source = "../../modules/security"

  name_prefix = local.name_prefix
  vpc_id      = module.network.vpc_id
  app_port    = var.vaultwarden_port
}

module "rds" {
  source = "../../modules/rds"

  name_prefix       = local.name_prefix
  db_subnet_ids     = values(module.network.db_subnet_ids_by_az)
  security_group_id = module.security.rds_security_group_id

  engine_version            = var.db_engine_version
  instance_class            = var.db_instance_class
  allocated_storage         = var.db_allocated_storage
  max_allocated_storage     = var.db_max_allocated_storage
  multi_az                  = var.db_multi_az
  backup_retention_period   = var.db_backup_retention_period
  deletion_protection       = var.db_deletion_protection
  skip_final_snapshot       = var.db_skip_final_snapshot
  final_snapshot_identifier = var.db_final_snapshot_identifier
}

module "secrets" {
  source = "../../modules/secrets"

  name_prefix             = local.name_prefix
  recovery_window_in_days = var.vaultwarden_secret_recovery_window_in_days
}

module "iam" {
  source = "../../modules/iam"

  name_prefix = local.name_prefix

  secret_arns = [
    module.secrets.vaultwarden_secret_arn
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

  name_prefix       = local.name_prefix
  vpc_id            = module.network.vpc_id
  public_subnet_ids = values(module.network.public_subnet_ids_by_az)
  security_group_id = module.security.alb_security_group_id
  certificate_arn   = module.acm.certificate_arn
  target_port       = var.vaultwarden_port

  enable_deletion_protection = var.alb_enable_deletion_protection
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

  name_prefix       = local.name_prefix
  subnet_ids_by_az  = module.network.app_subnet_ids_by_az
  security_group_id = module.security.efs_security_group_id
}

module "ecs" {
  source = "../../modules/ecs"

  name_prefix = local.name_prefix
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
  container_port         = var.vaultwarden_port

  efs_file_system_id  = module.efs.file_system_id
  efs_access_point_id = module.efs.access_point_id

  cpu                   = var.ecs_cpu
  memory                = var.ecs_memory
  desired_count         = var.ecs_desired_count
  log_retention_in_days = var.ecs_log_retention_in_days
  signups_allowed       = var.vaultwarden_signups_allowed
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"

  name_prefix = local.name_prefix

  ecs_cluster_name = module.ecs.cluster_name
  ecs_service_name = module.ecs.service_name

  load_balancer_arn_suffix = module.alb.load_balancer_arn_suffix
  target_group_arn_suffix  = module.alb.target_group_arn_suffix

  db_instance_identifier = module.rds.db_instance_identifier

  ecs_cpu_threshold              = var.cloudwatch_ecs_cpu_threshold
  ecs_memory_threshold           = var.cloudwatch_ecs_memory_threshold
  rds_cpu_threshold              = var.cloudwatch_rds_cpu_threshold
  rds_free_storage_threshold     = var.cloudwatch_rds_free_storage_threshold_bytes
  alb_unhealthy_target_threshold = var.cloudwatch_alb_unhealthy_target_threshold
  alarm_actions                  = var.cloudwatch_alarm_actions
}
