resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "${var.name_prefix}-ecs-cpu-high"
  alarm_description   = "ECS service CPU utilization is high."
  namespace           = "AWS/ECS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = var.utilization_period_seconds
  evaluation_periods  = var.utilization_evaluation_periods
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
  alarm_name          = "${var.name_prefix}-ecs-memory-high"
  alarm_description   = "ECS service memory utilization is high."
  namespace           = "AWS/ECS"
  metric_name         = "MemoryUtilization"
  statistic           = "Average"
  period              = var.utilization_period_seconds
  evaluation_periods  = var.utilization_evaluation_periods
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

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_targets" {
  alarm_name          = "${var.name_prefix}-alb-unhealthy-targets"
  alarm_description   = "ALB target group contains unhealthy targets."
  namespace           = "AWS/ApplicationELB"
  metric_name         = "UnHealthyHostCount"
  statistic           = "Minimum"
  period              = var.alb_period_seconds
  evaluation_periods  = var.alb_evaluation_periods
  threshold           = var.alb_unhealthy_target_threshold
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = var.treat_missing_data

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-alb-unhealthy-targets"
  })
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "${var.name_prefix}-rds-cpu-high"
  alarm_description   = "RDS CPU utilization is high."
  namespace           = "AWS/RDS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = var.utilization_period_seconds
  evaluation_periods  = var.utilization_evaluation_periods
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

resource "aws_cloudwatch_metric_alarm" "rds_free_storage_low" {
  alarm_name          = "${var.name_prefix}-rds-free-storage-low"
  alarm_description   = "RDS free storage space is low."
  namespace           = "AWS/RDS"
  metric_name         = "FreeStorageSpace"
  statistic           = "Minimum"
  period              = var.rds_storage_period_seconds
  evaluation_periods  = var.rds_storage_evaluation_periods
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
