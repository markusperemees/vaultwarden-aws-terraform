# Bootstrap

Creates the foundational AWS resources required by the Vaultwarden Terraform workflows.

## Resources

- Versioned and encrypted S3 bucket for Terraform state
- GitHub Actions OIDC provider
- Terraform plan role
- Terraform apply role
- ECR image push role

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

## State protection

The state bucket has versioning, server-side encryption, public-access blocking, and insecure-transport protection enabled. Terraform also prevents accidental bucket destruction.
