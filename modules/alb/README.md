# ALB module

Creates the public Application Load Balancer used by Vaultwarden.

## Resources

- Internet-facing Application Load Balancer across at least two public subnets
- HTTP listener that redirects port 80 to HTTPS
- HTTPS listener using an ACM certificate
- IP target group for ECS Fargate tasks
- HTTP health check for the Vaultwarden `/alive` endpoint

## Traffic flow

`Client HTTPS 443 -> ALB -> Target group HTTP 80 -> Fargate tasks`

The ALB terminates TLS. Fargate tasks accept traffic only from the ALB security group.

## Main inputs

| Name | Description | Default |
|---|---|---|
| `name_prefix` | Resource name prefix | Required |
| `vpc_id` | VPC ID | Required |
| `public_subnet_ids` | Public subnet IDs in at least two AZs | Required |
| `security_group_id` | ALB security group ID | Required |
| `certificate_arn` | ACM certificate ARN | Required |
| `target_port` | ECS task port | `80` |
| `ssl_policy` | HTTPS listener TLS policy | `ELBSecurityPolicy-TLS13-1-2-2021-06` |
| `enable_deletion_protection` | Protect ALB from deletion | `false` |
| `deregistration_delay_seconds` | Target draining period | `30` |
| `health_check_path` | Health check endpoint | `/alive` |
| `health_check_*` | Matcher, interval, timeout and thresholds | Production defaults |
| `tags` | Additional resource tags | `{}` |

## Outputs

The module exports the ALB ARN, DNS name, hosted zone ID, listener ARN, target group ARN, and CloudWatch ARN suffixes.

## Design decisions

HTTP and HTTPS listener ports are fixed module constants because this module implements a public web entry point. The TLS policy and health-check behavior remain configurable because they may change independently of the architecture.
