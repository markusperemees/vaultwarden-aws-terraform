terraform {
  backend "s3" {
    bucket       = "vaultwarden-636499496034-eu-north-1-tfstate"
    key          = "vaultwarden/prod/terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true
  }
}