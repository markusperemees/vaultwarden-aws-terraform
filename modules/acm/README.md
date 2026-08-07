# ACM module

Creates and validates the public ACM certificate used by the Vaultwarden Application Load Balancer.

## Resources

- ACM public certificate
- Route53 DNS validation record(s)
- ACM certificate validation workflow

## Key behavior

- DNS validation is enforced
- Replacement certificates are created before the previous certificate is destroyed
- DNS validation records are kept in Route53 for ACM managed renewal
- Optional Subject Alternative Names (SANs) are supported
- Validation-record TTL defaults to 60 seconds

`validation_method = "DNS"` and `create_before_destroy = true` are intentionally fixed because they define the certificate-management behavior of this module.

## Inputs

- `domain_name` — primary certificate domain
- `subject_alternative_names` — optional additional certificate domains
- `hosted_zone_id` — Route53 hosted zone used for validation
- `validation_record_ttl` — TTL for ACM validation CNAME records
- `tags` — additional certificate tags

## Outputs

- validated certificate ARN
- primary certificate domain
- DNS validation record FQDNs
