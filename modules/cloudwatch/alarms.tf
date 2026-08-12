# ------------------------------------------------------------------
# ECS
# ------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name        = "${var.name_prefix}-ecs-cpu-high"
  alarm_description = "ECS service CPU utilization is high."

  namespace   = "AWS/ECS"
  metric_name = "CPUUtilization"
  statistic   = "Average"

  period              = var.utilization_period_seconds
  evaluation_periods  = 5
  datapoints_to_alarm = 3

  threshold           = var.ecs_cpu_threshold
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = var.treat_missing_data

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ecs-cpu-high"
  })
}


resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {
  alarm_name        = "${var.name_prefix}-ecs-memory-high"
  alarm_description = "ECS service memory utilization is high."

  namespace   = "AWS/ECS"
  metric_name = "MemoryUtilization"
  statistic   = "Average"

  period              = var.utilization_period_seconds
  evaluation_periods  = 5
  datapoints_to_alarm = 3

  threshold           = var.ecs_memory_threshold
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = var.treat_missing_data

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ecs-memory-high"
  })
}


# ------------------------------------------------------------------
# ALB availability
# ------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "alb_no_healthy_targets" {
  alarm_name        = "${var.name_prefix}-alb-no-healthy-targets"
  alarm_description = "ALB has no healthy Vaultwarden targets."

  namespace   = "AWS/ApplicationELB"
  metric_name = "HealthyHostCount"
  statistic   = "Maximum"

  period              = 60
  evaluation_periods  = 2
  datapoints_to_alarm = 2

  threshold           = 1
  comparison_operator = "LessThanThreshold"

  # HealthyHostCount is only reported while targets are registered.
  # Missing data therefore counts as an availability problem.
  treat_missing_data = "breaching"

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-alb-no-healthy-targets"
  })
}


# ------------------------------------------------------------------
# ALB errors
# ------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "alb_target_5xx" {
  alarm_name        = "${var.name_prefix}-alb-target-5xx"
  alarm_description = "Vaultwarden targets are returning HTTP 5xx responses."

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_Target_5XX_Count"
  statistic   = "Sum"

  period              = 300
  evaluation_periods  = 2
  datapoints_to_alarm = 2

  threshold           = var.alb_target_5xx_threshold
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-alb-target-5xx"
  })
}


resource "aws_cloudwatch_metric_alarm" "alb_elb_5xx" {
  alarm_name        = "${var.name_prefix}-alb-elb-5xx"
  alarm_description = "Application Load Balancer is returning HTTP 5xx responses."

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_ELB_5XX_Count"
  statistic   = "Sum"

  period              = 60
  evaluation_periods  = 2
  datapoints_to_alarm = 2

  threshold           = var.alb_elb_5xx_threshold
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-alb-elb-5xx"
  })
}


# ------------------------------------------------------------------
# ALB performance
# ------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "alb_latency_high" {
  alarm_name        = "${var.name_prefix}-alb-latency-high"
  alarm_description = "Vaultwarden p95 target response time is high."

  namespace          = "AWS/ApplicationELB"
  metric_name        = "TargetResponseTime"
  extended_statistic = "p95"

  period              = 60
  evaluation_periods  = 5
  datapoints_to_alarm = 3

  threshold           = var.alb_latency_threshold_seconds
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-alb-latency-high"
  })
}


# ------------------------------------------------------------------
# RDS CPU
# ------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name        = "${var.name_prefix}-rds-cpu-high"
  alarm_description = "RDS CPU utilization is consistently high."

  namespace   = "AWS/RDS"
  metric_name = "CPUUtilization"
  statistic   = "Average"

  period              = 60
  evaluation_periods  = 3
  datapoints_to_alarm = 3

  threshold           = var.rds_cpu_threshold
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = var.treat_missing_data

  dimensions = {
    DBInstanceIdentifier = var.db_instance_identifier
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-rds-cpu-high"
  })
}


# ------------------------------------------------------------------
# RDS storage
# ------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "rds_free_storage_low" {
  alarm_name        = "${var.name_prefix}-rds-free-storage-low"
  alarm_description = "RDS free storage space is low."

  namespace   = "AWS/RDS"
  metric_name = "FreeStorageSpace"
  statistic   = "Minimum"

  period              = 300
  evaluation_periods  = 1
  datapoints_to_alarm = 1

  threshold           = var.rds_free_storage_threshold
  comparison_operator = "LessThanOrEqualToThreshold"
  treat_missing_data  = var.treat_missing_data

  dimensions = {
    DBInstanceIdentifier = var.db_instance_identifier
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-rds-free-storage-low"
  })
}


# ------------------------------------------------------------------
# RDS memory
# ------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "rds_freeable_memory_low" {
  alarm_name        = "${var.name_prefix}-rds-freeable-memory-low"
  alarm_description = "RDS freeable memory is consistently low."

  namespace   = "AWS/RDS"
  metric_name = "FreeableMemory"
  statistic   = "Average"

  period              = 300
  evaluation_periods  = 3
  datapoints_to_alarm = 3

  threshold           = var.rds_freeable_memory_threshold
  comparison_operator = "LessThanOrEqualToThreshold"
  treat_missing_data  = var.treat_missing_data

  dimensions = {
    DBInstanceIdentifier = var.db_instance_identifier
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-rds-freeable-memory-low"
  })
}


# ------------------------------------------------------------------
# RDS surprise-bill protection
# ------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "rds_cpu_surplus_credits_charged" {
  alarm_name        = "${var.name_prefix}-rds-cpu-surplus-credits-charged"
  alarm_description = "RDS has incurred charges for surplus CPU credits."

  namespace   = "AWS/RDS"
  metric_name = "CPUSurplusCreditsCharged"
  statistic   = "Maximum"

  # RDS CPU credit metrics are emitted every five minutes.
  period              = 300
  evaluation_periods  = 1
  datapoints_to_alarm = 1

  threshold           = 0
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = var.db_instance_identifier
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-rds-cpu-surplus-credits-charged"
  })
}