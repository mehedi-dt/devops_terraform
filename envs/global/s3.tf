locals {
    s3 = {
        "project-1-${var.env}-${var.region}" = {
            is_public = true
            is_version = false
            bucket_policy_file_path = "../templates/bucket_policy/project-1.json.tmpl"
        }

        "project-2-${var.env}-${var.region}" = {
            is_public = false
            is_version = false
        }

        "project-3-${var.env}-${var.region}" = {
            is_public = true
            is_version = false
        }
    }
}

module "s3" {
    source = "../../modules/s3"
    for_each = local.s3
    
    env = var.env
    name = lookup(each.value, "name", each.key)
    is_public = lookup(each.value, "is_public", false)
    is_version = lookup(each.value, "is_versionlookup", false)
    bucket_policy = templatefile(
        lookup(each.value, "bucket_policy_file_path", "../templates/bucket_policy/public_default.json.tmpl"),
        { bucket_name = each.key }
    )
}

# Retrieve the outputs
output "s3_id" {
    description = "S3 ID"
    value = { for k, v in module.s3 : k => v.id }
}

output "s3_arn" {
    description = "S3 ARN"
    value = { for k, v in module.s3 : k => v.arn }
}