output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_ids_by_az" {
  description = "Public subnet IDs mapped by availability zone."
  value       = { for az, subnet in aws_subnet.public : az => subnet.id }
}

output "app_subnet_ids_by_az" {
  description = "Application subnet IDs mapped by availability zone."
  value       = { for az, subnet in aws_subnet.app : az => subnet.id }
}

output "db_subnet_ids_by_az" {
  description = "Database subnet IDs mapped by availability zone."
  value       = { for az, subnet in aws_subnet.db : az => subnet.id }
}