# IAM module

Creates the IAM roles and least-privilege permissions required by the Vaultwarden ECS tasks.

## Resources

- ECS task execution role
- ECS task role
- Attachment of the AWS-managed `AmazonECSTaskExecutionRolePolicy`
- Inline permission for the execution role to read the configured Secrets Manager secrets
- Inline permission for the task role to mount and write to the configured EFS file system through the configured access point

## Role responsibilities

The **task execution role** is used by ECS/Fargate to start the task, pull the image, write logs, and retrieve injected secrets.

The **task role** is used by the running Vaultwarden container. In this project it only receives the EFS client permissions required for persistent `/data` storage.

## Security model

Permissions are intentionally resource-scoped where AWS supports it:

- Secrets Manager access is limited to the supplied secret ARNs.
- EFS access is limited to the supplied file-system ARN and access-point ARN.
- `ClientRootAccess` is not granted.
- The trust policy only allows `ecs-tasks.amazonaws.com` to assume the roles.

The AWS-managed ECS task execution policy is treated as a fixed service dependency rather than a caller-configurable permission set.

## Inputs

Important inputs are the resource-name prefix, Secrets Manager ARNs, EFS file-system/access-point ARNs, and common tags.

## Outputs

The module exports the names and ARNs of both ECS IAM roles.
