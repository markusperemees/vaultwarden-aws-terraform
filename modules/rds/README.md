# RDS module

Creates the PostgreSQL database layer used by Vaultwarden.

## Resources

- RDS PostgreSQL DB instance
- DB subnet group across private database subnets
- AWS-managed master password in Secrets Manager
- Optional Multi-AZ deployment
- Automated backups and final snapshot protection
- PostgreSQL log export to CloudWatch

## Key defaults

- PostgreSQL
- Multi-AZ enabled
- `db.t4g.micro`
- 20 GiB initial gp3 storage
- Storage autoscaling up to 100 GiB
- 7-day backup retention
- Storage encryption enabled
- Public access disabled
- Deletion protection enabled
- Final snapshot required

Security-sensitive settings such as storage encryption, private-only access, and AWS-managed master credentials are intentionally enforced by the module.

## Inputs

Important inputs include the DB subnet IDs, security group ID, PostgreSQL version, instance class, storage settings, backup retention, Multi-AZ configuration, and common tags.

## Outputs

The module exports the DB identifier, ARN, endpoint, address, port, and the ARN of the AWS-managed master-user secret.

When an older final snapshot is retained, set `final_snapshot_identifier` to a new unique value before the next destroy.
