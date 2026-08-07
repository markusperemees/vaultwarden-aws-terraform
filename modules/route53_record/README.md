# Route53 record module

Creates the public DNS alias record that points the Vaultwarden hostname to the Application Load Balancer.

## Resource

- Route53 `A` alias record

## Behavior

The record points `record_name` in the supplied hosted zone to the ALB DNS name and canonical hosted zone ID.

`type = "A"` and `evaluate_target_health = true` are intentionally fixed because this module is specifically designed to create an ALB alias record.

## Inputs

- `zone_id` — Route53 hosted zone ID
- `record_name` — DNS record name, for example `vault.example.com`
- `alb_dns_name` — ALB DNS name
- `alb_zone_id` — ALB canonical hosted zone ID

All required string inputs are validated to ensure they are not empty.

## Outputs

- `record_fqdn` — fully qualified domain name of the created Route53 alias record
