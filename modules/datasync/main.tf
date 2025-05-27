resource "aws_iam_role" "datasync_role" {
  name = "datasync-for-${var.destination_bucket}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "datasync.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "datasync_policy" {
  name = "datasync-policy-${var.source_bucket}"
  role = aws_iam_role.datasync_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:Get*", "s3:List*"],
        Resource = [
          "arn:aws:s3:::${var.source_bucket}",
          "arn:aws:s3:::${var.source_bucket}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = ["s3:Get*", "s3:PutObject*", "s3:List*", "s3:DeleteObject"],
        Resource = [
          "arn:aws:s3:::${var.destination_bucket}",
          "arn:aws:s3:::${var.destination_bucket}/*"
        ]
      }
    ]
  })
}

resource "aws_datasync_location_s3" "source" {
  provider = aws.source_provider

  s3_bucket_arn = "arn:aws:s3:::${var.source_bucket}"
  subdirectory  = var.source_prefix

  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync_role.arn
  }
}


resource "aws_datasync_location_s3" "destination" {
  s3_bucket_arn = "arn:aws:s3:::${var.destination_bucket}"
  subdirectory  = var.destination_prefix

  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync_role.arn
  }
}

resource "aws_datasync_task" "s3_sync_task" {
  name = "sync-for-${var.destination_bucket}"

  source_location_arn      = aws_datasync_location_s3.source.arn
  destination_location_arn = aws_datasync_location_s3.destination.arn

  dynamic "schedule" {
    for_each = var.schedule_expression != null ? [1] : []
    content {
      schedule_expression = var.schedule_expression
    }
  }

  options {
    overwrite_mode         = var.overwrite_mode
    preserve_deleted_files = var.preserve_deleted_files
    verify_mode            = var.verify_mode
    posix_permissions = var.posix_permissions
    uid = var.uid
    gid = var.gid
  }
}