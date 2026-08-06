# Security module

Creates security groups and traffic rules for the Vaultwarden ALB, ECS tasks, RDS database and EFS mount targets.

## Traffic rules

| Source | Destination | Protocol/port | Purpose |
|---|---|---:|---|
| Configured IPv4 CIDR | ALB | TCP 80 | Redirect HTTP to HTTPS |
| Configured IPv4 CIDR | ALB | TCP 443 | Public HTTPS access |
| ALB security group | ECS security group | TCP `app_port` | Application traffic |
| ECS security group | RDS security group | TCP `db_port` | PostgreSQL access |
| ECS security group | EFS security group | TCP 2049 | EFS/NFS access |
| ECS tasks | Configured IPv4 CIDR | All outbound | AWS services and external dependencies |

Security-group references are used for internal traffic instead of subnet CIDRs.

## Usage

```hcl
module "security" {
  source = "../../modules/security"

  name_prefix = local.name_prefix
  vpc_id      = module.network.vpc_id
  app_port    = 80
  db_port     = 5432

  tags = local.common_tags
}
```

## Inputs

- `name_prefix` — prefix used for resource names.
- `vpc_id` — VPC in which the security groups are created.
- `app_port` — application container port. Default: `80`.
- `db_port` — PostgreSQL port. Default: `5432`.
- `alb_ingress_ipv4_cidr` — IPv4 range allowed to access the ALB. Default: `0.0.0.0/0`.
- `ecs_egress_ipv4_cidr` — IPv4 range allowed for ECS outbound traffic. Default: `0.0.0.0/0`.
- `tags` — additional tags applied to security groups.

## Outputs

- `alb_security_group_id`
- `ecs_security_group_id`
- `rds_security_group_id`
- `efs_security_group_id`
