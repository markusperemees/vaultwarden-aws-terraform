resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${var.name_prefix}"
  retention_in_days = var.log_retention_in_days

  tags = {
    Name = "${var.name_prefix}-ecs-logs"
  }
}

resource "aws_ecs_cluster" "this" {
  name = "${var.name_prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enhanced"
  }

  tags = {
    Name = "${var.name_prefix}-cluster"
  }
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
      name      = "vaultwarden"
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
          value = "/data"
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
          sourceVolume  = "vaultwarden-data"
          containerPath = "/data"
          readOnly      = false
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "vaultwarden"
        }
      }
    }
  ])

  volume {
    name = "vaultwarden-data"

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

  tags = {
    Name = "${var.name_prefix}-task-definition"
  }
}

resource "aws_ecs_service" "this" {
  name            = "${var.name_prefix}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  platform_version = "LATEST"

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = var.app_subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "vaultwarden"
    container_port   = var.container_port
  }

  propagate_tags = "SERVICE"

  tags = {
    Name = "${var.name_prefix}-service"
  }
}