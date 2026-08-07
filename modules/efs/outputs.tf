output "file_system_id" {
  description = "ID of the EFS file system."
  value       = aws_efs_file_system.this.id
}

output "file_system_arn" {
  description = "ARN of the EFS file system."
  value       = aws_efs_file_system.this.arn
}

output "access_point_id" {
  description = "ID of the EFS access point."
  value       = aws_efs_access_point.this.id
}

output "access_point_arn" {
  description = "ARN of the EFS access point."
  value       = aws_efs_access_point.this.arn
}

output "mount_target_ids_by_az" {
  description = "EFS mount target IDs mapped by availability zone."
  value       = { for az, target in aws_efs_mount_target.this : az => target.id }
}