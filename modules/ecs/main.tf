locals {
  container_name    = "vaultwarden"
  data_path         = "/data"
  volume_name       = "vaultwarden-data"
  log_stream_prefix = "vaultwarden"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${var.name_prefix}"
  retention_in_days = var.log_retention_in_days

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ecs-logs"
  })
}

resource "aws_ecs_cluster" "this" {
  name = "${var.name_prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = var.container_insights_mode
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-cluster"
  })
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.name_prefix
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = var.cpu
  memory = var.memory

  execution_role_arn = var.task_execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = local.container_name
      image     = "${var.repository_url}:${var.image_tag}"
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "DOMAIN"
          value = "https://${var.domain_name}"
        },
        {
          name  = "DATA_FOLDER"
          value = local.data_path
        },
        {
          name  = "ROCKET_PORT"
          value = tostring(var.container_port)
        },
        {
          name  = "SIGNUPS_ALLOWED"
          value = tostring(var.signups_allowed)
        }
      ]

      secrets = [
        {
          name      = "ADMIN_TOKEN"
          valueFrom = "${var.application_secret_arn}:ADMIN_TOKEN::"
        },
        {
          name      = "DATABASE_URL"
          valueFrom = "${var.application_secret_arn}:DATABASE_URL::"
        }
      ]

      mountPoints = [
        {
          sourceVolume  = local.volume_name
          containerPath = local.data_path
          readOnly      = false
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = local.log_stream_prefix
        }
      }
    }
  ])

  volume {
    name = local.volume_name

    efs_volume_configuration {
      file_system_id     = var.efs_file_system_id
      root_directory     = "/"
      transit_encryption = "ENABLED"

      authorization_config {
        access_point_id = var.efs_access_point_id
        iam             = "ENABLED"
      }
    }
  }

  lifecycle {
    precondition {
      condition = (
        (var.cpu == 256 && contains([512, 1024, 2048], var.memory)) ||
        (var.cpu == 512 && contains([1024, 2048, 3072, 4096], var.memory)) ||
        (var.cpu == 1024 && var.memory >= 2048 && var.memory <= 8192 && var.memory % 1024 == 0) ||
        (var.cpu == 2048 && var.memory >= 4096 && var.memory <= 16384 && var.memory % 1024 == 0) ||
        (var.cpu == 4096 && var.memory >= 8192 && var.memory <= 30720 && var.memory % 1024 == 0) ||
        (var.cpu == 8192 && var.memory >= 16384 && var.memory <= 61440 && var.memory % 4096 == 0) ||
        (var.cpu == 16384 && var.memory >= 32768 && var.memory <= 122880 && var.memory % 8192 == 0) ||
        (var.cpu == 32768 && contains([61440, 122880, 249856], var.memory))
      )
      error_message = "The selected cpu and memory values are not a valid AWS Fargate task size combination."
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-task-definition"
  })
}

resource "aws_ecs_service" "this" {
  name            = "${var.name_prefix}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  platform_version              = var.fargate_platform_version
  availability_zone_rebalancing = var.availability_zone_rebalancing ? "ENABLED" : "DISABLED"

  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds

  deployment_circuit_breaker {
    enable   = var.deployment_circuit_breaker_enabled
    rollback = var.deployment_rollback_enabled
  }

  network_configuration {
    subnets          = var.app_subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = local.container_name
    container_port   = var.container_port
  }

  propagate_tags = "SERVICE"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-service"
  })
}
