# General

aws_region = "eu-north-1"

# Network

vpc_cidr = "10.0.0.0/16"

subnets = {
  eu-north-1a = {
    public_cidr = "10.0.0.0/24"
    app_cidr    = "10.0.10.0/24"
    db_cidr     = "10.0.20.0/24"
  }

  eu-north-1b = {
    public_cidr = "10.0.1.0/24"
    app_cidr    = "10.0.11.0/24"
    db_cidr     = "10.0.21.0/24"
  }
}

# RDS

db_engine_version          = "17.10"
db_instance_class          = "db.t4g.micro"
db_allocated_storage       = 20
db_max_allocated_storage   = 100
db_multi_az                = true
db_backup_retention_period = 7
db_deletion_protection     = true
db_skip_final_snapshot     = false

# DNS and Vaultwarden

domain_name                 = "mperem.tech"
vaultwarden_domain_name     = "vault.mperem.tech"
vaultwarden_image_tag       = "1.37.0"
vaultwarden_port            = 80
vaultwarden_signups_allowed = false

# ECS

ecs_desired_count         = 1
ecs_cpu                   = 256
ecs_memory                = 512
ecs_log_retention_in_days = 30

# ALB

alb_enable_deletion_protection = true

# ECR

ecr_untagged_image_retention_days = 1
ecr_tagged_image_retention_count  = 10

# Secrets Manager

vaultwarden_secret_recovery_window_in_days = 7

# CloudWatch

cloudwatch_ecs_cpu_threshold                = 80
cloudwatch_ecs_memory_threshold             = 80
cloudwatch_rds_cpu_threshold                = 80
cloudwatch_rds_free_storage_threshold_bytes = 5368709120
cloudwatch_alb_unhealthy_target_threshold   = 0
cloudwatch_alarm_actions = [
  "arn:aws:sns:eu-north-1:636499496034:vaultwarden-prod-alerts"
]
