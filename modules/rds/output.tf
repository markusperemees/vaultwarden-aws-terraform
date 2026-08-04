output "db_instance_id" {
  description = "ID of the RDS instance."
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "ARN of the RDS instance."
  value       = aws_db_instance.this.arn
}

output "db_endpoint" {
  description = "Connection endpoint of the RDS instance."
  value       = aws_db_instance.this.endpoint
}

output "db_address" {
  description = "Hostname of the RDS instance."
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "Port of the RDS instance."
  value       = aws_db_instance.this.port
}

output "master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret containing master credentials."
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}