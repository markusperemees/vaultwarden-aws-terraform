output "alarm_arns" {
  description = "ARNs of the CloudWatch alarms."
  value = {
    ecs_cpu_high          = aws_cloudwatch_metric_alarm.ecs_cpu_high.arn
    ecs_memory_high       = aws_cloudwatch_metric_alarm.ecs_memory_high.arn
    alb_unhealthy_targets = aws_cloudwatch_metric_alarm.alb_unhealthy_targets.arn
    rds_cpu_high          = aws_cloudwatch_metric_alarm.rds_cpu_high.arn
    rds_free_storage_low  = aws_cloudwatch_metric_alarm.rds_free_storage_low.arn
  }
}