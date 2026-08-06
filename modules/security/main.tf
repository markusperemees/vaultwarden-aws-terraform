locals {
  http_port  = 80
  https_port = 443
  nfs_port   = 2049
}

resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Security group for the application load balancer."
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-alb-sg"
  })
}

resource "aws_security_group" "ecs" {
  name        = "${var.name_prefix}-ecs-sg"
  description = "Security group for ECS Fargate tasks."
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ecs-sg"
  })
}

resource "aws_security_group" "rds" {
  name        = "${var.name_prefix}-rds-sg"
  description = "Security group for the RDS database."
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-rds-sg"
  })
}

resource "aws_security_group" "efs" {
  name        = "${var.name_prefix}-efs-sg"
  description = "Security group for EFS mount targets."
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-efs-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = var.alb_ingress_ipv4_cidr
  from_port         = local.https_port
  to_port           = local.https_port
  ip_protocol       = "tcp"

  description = "Allow HTTPS traffic to the ALB."
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = var.alb_ingress_ipv4_cidr
  from_port         = local.http_port
  to_port           = local.http_port
  ip_protocol       = "tcp"

  description = "Allow HTTP traffic to the ALB for HTTPS redirection."
}

resource "aws_vpc_security_group_egress_rule" "alb_to_ecs" {
  security_group_id            = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.ecs.id
  from_port                    = var.app_port
  to_port                      = var.app_port
  ip_protocol                  = "tcp"

  description = "Allow application traffic from the ALB to ECS tasks."
}

resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id            = aws_security_group.ecs.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = var.app_port
  to_port                      = var.app_port
  ip_protocol                  = "tcp"

  description = "Allow application traffic from the ALB."
}

resource "aws_vpc_security_group_egress_rule" "ecs_all" {
  security_group_id = aws_security_group.ecs.id
  cidr_ipv4         = var.ecs_egress_ipv4_cidr
  ip_protocol       = "-1"

  description = "Allow outbound traffic from ECS tasks."
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_ecs" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.ecs.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"

  description = "Allow database traffic from ECS tasks."
}

resource "aws_vpc_security_group_ingress_rule" "efs_from_ecs" {
  security_group_id            = aws_security_group.efs.id
  referenced_security_group_id = aws_security_group.ecs.id
  from_port                    = local.nfs_port
  to_port                      = local.nfs_port
  ip_protocol                  = "tcp"

  description = "Allow NFS traffic from ECS tasks."
}