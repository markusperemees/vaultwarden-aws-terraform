# ECS module

Creates the Vaultwarden ECS Fargate compute layer.

## Resources

- ECS cluster with Container Insights
- Fargate task definition
- ECS service across private application subnets
- CloudWatch log group
- EFS mount through an access point
- ALB target group integration
- Secrets Manager injection for `ADMIN_TOKEN` and `DATABASE_URL`

## Design

Tasks use `awsvpc` networking and do not receive public IP addresses. The service is intended to run across at least two private application subnets and can rebalance tasks across Availability Zones. Vaultwarden data is mounted from EFS with encryption in transit and IAM authorization enabled.

The deployment circuit breaker and automatic rollback are enabled by default. The default deployment settings keep 100% of the desired tasks healthy while allowing up to 200% during a rolling deployment.

## Main inputs

- `app_subnet_ids` - private subnets for Fargate tasks
- `security_group_id` - ECS task security group
- `target_group_arn` - ALB target group
- `repository_url` / `image_tag` - container image
- `application_secret_arn` - Vaultwarden application secret
- `efs_file_system_id` / `efs_access_point_id` - persistent storage
- `cpu` / `memory` - Fargate task size
- `desired_count` - number of running tasks

## Outputs

- ECS cluster name and ARN
- ECS service name and ARN
- task definition ARN
- CloudWatch log group name
