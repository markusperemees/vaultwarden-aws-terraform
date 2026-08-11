# Bootstrap

Creates the foundational AWS resources required by the Vaultwarden Terraform workflows.

## Resources

- Versioned and encrypted S3 bucket for Terraform state
- GitHub Actions OIDC provider
- Terraform plan role
- Terraform apply role
- ECR image push role
- Account-wide monthly AWS cost budget
- Shared SNS topic and email subscription for cost and operational alerts

## Prerequisites

- Terraform `1.15.x`
- AWS credentials with permission to create S3, IAM, and OIDC resources
- GitHub repository owner and repository names and numeric IDs

## Initial setup

Copy the example variables file and replace every placeholder:

```shell
cp terraform.tfvars.example terraform.tfvars
```

For a new AWS account, the state bucket must exist before the S3 backend can be initialized:

1. Temporarily move `backend.tf` outside the `bootstrap` directory.
2. Initialize Terraform with local state:

   ```shell
   terraform init
   terraform apply
   ```

3. Restore `backend.tf` and ensure its bucket matches `state_bucket_name`.
4. Migrate the local state into S3:

   ```shell
   terraform init -migrate-state
   ```

Keep the local state file until the migration has completed successfully.

## Existing deployment

When the state bucket and remote state already exist:

```shell
terraform init
terraform plan
```

## GitHub configuration

Use the Terraform outputs to configure these GitHub repository variables:

- `TF_STATE_BUCKET`
- `AWS_TERRAFORM_PLAN_ROLE_ARN`
- `AWS_TERRAFORM_APPLY_ROLE_ARN`
- `AWS_ECR_PUSH_ROLE_ARN`

The apply role is restricted to jobs using the protected GitHub `prod` environment.

## Cost budget

The bootstrap layer creates a recurring account-wide monthly AWS cost budget. The default limit is `30 USD` and can be changed with `monthly_budget_limit_usd`.

Budget alerts are published to the shared SNS topic at 50%, 80%, and 100% of actual monthly spend, and at 100% of forecasted monthly spend. Set `alert_email_address` to the notification recipient. After the first apply, the recipient must confirm the subscription using the link sent by Amazon SNS.

## State protection

The state bucket has versioning, server-side encryption, public-access blocking, and insecure-transport protection enabled. A configurable lifecycle rule retains recent noncurrent state versions while expiring older versions and incomplete multipart uploads. Terraform also prevents accidental bucket destruction.
