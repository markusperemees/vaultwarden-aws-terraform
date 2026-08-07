# CloudWatch module

Creates CloudWatch metric alarms for the Vaultwarden production stack.

## Alarms

- ECS service CPU utilization
- ECS service memory utilization
- ALB unhealthy target count
- RDS CPU utilization
- RDS free storage space

## Key defaults

- ECS/RDS utilization threshold: 80%
- Utilization period: 60 seconds
- Utilization evaluation window: 5 periods
- ALB unhealthy target threshold: greater than 0
- ALB evaluation window: 2 × 60 seconds
- RDS free-storage threshold: 5 GiB
- RDS storage evaluation window: 1 × 300 seconds
- Missing data is treated as not breaching

Alarm and recovery actions use the ARNs supplied through `alarm_actions`. This can later be connected to an SNS topic for email or SMS notifications.

Metric namespaces, metric names, statistics, comparison operators, and dimensions are intentionally defined by the module because they describe the specific health conditions being monitored.

## Outputs

The module exports a map of CloudWatch alarm ARNs.
