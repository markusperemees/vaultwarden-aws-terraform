output "alarm_arns" {
  description = "ARNs of CloudWatch alarms."

  value = {
    ecs_cpu_high                    = aws_cloudwatch_metric_alarm.ecs_cpu_high.arn
    ecs_memory_high                 = aws_cloudwatch_metric_alarm.ecs_memory_high.arn
    alb_no_healthy_targets          = aws_cloudwatch_metric_alarm.alb_no_healthy_targets.arn
    alb_target_5xx                  = aws_cloudwatch_metric_alarm.alb_target_5xx.arn
    alb_elb_5xx                     = aws_cloudwatch_metric_alarm.alb_elb_5xx.arn
    alb_latency_high                = aws_cloudwatch_metric_alarm.alb_latency_high.arn
    rds_cpu_high                    = aws_cloudwatch_metric_alarm.rds_cpu_high.arn
    rds_free_storage_low            = aws_cloudwatch_metric_alarm.rds_free_storage_low.arn
    rds_freeable_memory_low         = aws_cloudwatch_metric_alarm.rds_freeable_memory_low.arn
    rds_cpu_surplus_credits_charged = aws_cloudwatch_metric_alarm.rds_cpu_surplus_credits_charged.arn
  }
}