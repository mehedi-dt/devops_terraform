locals {
    data-sync = {
    }
}

# for 
module "datasync" {
    source = "../../modules/datasync"
    for_each = local.data-sync

    source_bucket      = each.value.source_bucket
    destination_bucket = lookup(each.value, "destination_bucket", each.key)
    source_prefix      = lookup(each.value, "source_prefix", "/")
    destination_prefix = lookup(each.value, "destination_prefix", "/")
    overwrite_mode     = lookup(each.value, "overwrite_mode", "ALWAYS") # ALWAYS | NEVER
    preserve_deleted_files = lookup(each.value, "preserve_deleted_files", "REMOVE") # PRESERVE | REMOVE
    verify_mode            = lookup(each.value, "verify_mode", "NONE") # NONE | POINT_IN_TIME_CONSISTENT | ONLY_FILES_TRANSFERRED
    posix_permissions = lookup(each.value, "posix_permissions", "NONE") # NONE | PRESERVE [used for NFS/FSx]
    uid = lookup(each.value, "uid", "NONE") # NONE | INT_VALUE [used for NFS/FSx]
    gid = lookup(each.value, "gid", "NONE") # NONE | INT_VALUE [used for NFS/FSx]
    schedule_expression = lookup(each.value, "schedule_expression", null) # cron(0 2 * * ? *) - Every day at 2:00 AM UTC, rate(1 day) - daily



    providers = {
      aws.source_provider = aws.apse1
    }
}

output "datasync_task" {
    value = {for k, v in module.datasync : k => v.task_name}
}