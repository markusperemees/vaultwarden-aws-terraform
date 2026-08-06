# Network module

Creates the VPC networking used by Vaultwarden across two or more Availability Zones.

## Resources

- One VPC and Internet Gateway
- Public, private application, and private database subnet in each AZ
- One shared public route table
- One NAT Gateway and application route table per AZ
- Isolated database route tables without an internet default route

## Usage

```hcl
module "network" {
  source = "../../modules/network"

  name_prefix = "vaultwarden-prod"
  vpc_cidr    = "10.0.0.0/16"

  subnets = {
    eu-north-1a = {
      public_cidr = "10.0.0.0/24"
      app_cidr    = "10.0.10.0/24"
      db_cidr     = "10.0.20.0/24"
    }
    eu-north-1b = {
      public_cidr = "10.0.1.0/24"
      app_cidr    = "10.0.11.0/24"
      db_cidr     = "10.0.21.0/24"
    }
  }

  tags = {
    Project     = "vaultwarden"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}
```

## Inputs

| Name | Description | Required | Default |
|---|---|---:|---|
| `name_prefix` | Prefix used for resource names | Yes | — |
| `vpc_cidr` | VPC IPv4 CIDR block | Yes | — |
| `subnets` | Public, app, and DB CIDRs mapped by AZ | Yes | — |
| `public_subnet_map_public_ip_on_launch` | Auto-assign public IPv4 addresses to EC2 instances | No | `false` |
| `tags` | Additional resource tags | No | `{}` |

## Outputs

| Name | Description |
|---|---|
| `vpc_id` | VPC ID |
| `public_subnet_ids_by_az` | Public subnet IDs mapped by AZ |
| `app_subnet_ids_by_az` | Application subnet IDs mapped by AZ |
| `db_subnet_ids_by_az` | Database subnet IDs mapped by AZ |
