provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = local.project_name
      ManagedBy = "Terraform"
      Component = "Bootstrap"
    }
  }
}