# Route53 module

Creates the public Route53 hosted zone used for the Vaultwarden domain.

## Resource

- Public Route53 hosted zone

## Behavior

The module creates one public hosted zone for `domain_name`. It intentionally does not define a `vpc` block, because this project requires public DNS rather than a Route53 private hosted zone.

The hosted zone receives a `Name` tag automatically and accepts additional common tags through `tags`.

## Inputs

- `domain_name` — lowercase root domain managed by Route53
- `tags` — additional tags applied to the hosted zone

The domain name is validated for overall length and DNS label structure.

## Outputs

- `zone_id` — hosted zone ID
- `zone_arn` — hosted zone ARN
- `domain_name` — managed domain
- `name_servers` — authoritative Route53 name servers

The `name_servers` output is useful when the domain registrar must be configured to delegate the domain to Route53.
