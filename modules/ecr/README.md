# ECR module

Creates the private Amazon ECR repository used to store the Vaultwarden container image.

## Resources

- Private ECR repository
- ECR lifecycle policy

## Key defaults

- Image tags are immutable
- Scan on push enabled
- AES-256 encryption at rest
- Untagged images expire after 1 day
- Latest 10 tagged images are retained

## Configuration

The repository name, tag mutability, scan-on-push behavior, encryption type, lifecycle retention values, and common tags are configurable.

When `encryption_type = "KMS"`, `kms_key_arn` may be supplied for a customer-managed key. If it is omitted, ECR can use the AWS-managed ECR KMS key.

The lifecycle policy intentionally applies its tagged-image retention rule to all tagged images.

## Outputs

The module exports the repository name, URL, and ARN.

## Note on image scanning

Amazon ECR now recommends configuring scanning at the private-registry level. Repository-level `scan_on_push` is retained here to preserve the current project behavior and can be migrated separately later.
