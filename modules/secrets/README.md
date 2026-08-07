# Secrets module

Creates the AWS Secrets Manager secret container used for Vaultwarden application secrets.

## Resource

- Secrets Manager secret metadata

## Key defaults

- Secret name: `<name_prefix>/vaultwarden`
- Recovery window: 7 days
- Encryption uses the AWS managed `aws/secretsmanager` KMS key unless `kms_key_id` is supplied
- Common tags are supported

## Secret values

This module intentionally does **not** create an `aws_secretsmanager_secret_version` resource.

That keeps the actual Vaultwarden secret value out of Terraform configuration and avoids managing the plaintext secret payload through Terraform state. Secret values should be populated separately through the approved operational workflow.

## Inputs

- `name_prefix` — resource naming prefix
- `description` — secret description
- `recovery_window_in_days` — deletion recovery window from 7 to 30 days
- `kms_key_id` — optional customer-managed KMS key
- `tags` — additional resource tags

## Outputs

- `vaultwarden_secret_arn`
- `vaultwarden_secret_name`
