resource "aws_efs_file_system" "this" {
  encrypted = true

  lifecycle_policy {
    transition_to_ia = var.transition_to_ia
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-efs"
  })
}

resource "aws_efs_backup_policy" "this" {
  file_system_id = aws_efs_file_system.this.id

  backup_policy {
    status = "ENABLED"
  }
}

resource "aws_efs_access_point" "this" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    uid = var.access_point_uid
    gid = var.access_point_gid
  }

  root_directory {
    path = var.access_point_path

    creation_info {
      owner_uid   = var.access_point_uid
      owner_gid   = var.access_point_gid
      permissions = var.access_point_permissions
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-efs-access-point"
  })
}

resource "aws_efs_mount_target" "this" {
  for_each = var.subnet_ids_by_az

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = [var.security_group_id]
}
