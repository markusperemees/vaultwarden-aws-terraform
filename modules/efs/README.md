# EFS module

Creates the shared persistent file storage used by Vaultwarden ECS tasks.

## Resources

- Encrypted Amazon EFS file system
- EFS automatic backup policy
- EFS access point for the Vaultwarden data directory
- One EFS mount target per application subnet / Availability Zone

## Key defaults

- Encryption at rest enabled
- Automatic backups enabled through AWS Backup
- File system destruction blocked with Terraform `prevent_destroy`
- Files transition to EFS Infrequent Access after 30 days without access
- Access point path: `/vaultwarden`
- POSIX UID/GID: `1000`
- Access point permissions: `0750`

The file system is shared by ECS tasks across Availability Zones. Each task reaches EFS through the mount target in its own AZ.

## Inputs

Important inputs include the application subnet map, EFS security group, lifecycle transition, access point POSIX settings, and common tags.

## Outputs

The module exports the EFS file system ID/ARN, access point ID/ARN, and mount target IDs by Availability Zone.
