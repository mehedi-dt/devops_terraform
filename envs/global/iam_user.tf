locals {
  iam_user = {
    "project-1-${var.env}-${var.region}" = {
      access_key = true
      access_key_status = "Active"
      policy = templatefile( "../templates/iam_policy/s3_iam_default.json.tmpl",
        { bucket_name = "project-1-${var.env}-${var.region}" }
      )
    }
  }
}

module "iam_user" {
  source = "../../modules/iam_user"
  for_each = local.iam_user

  name = lookup(each.value, "name", each.key)
  policy = each.value.policy
  access_key = (lookup(each.value, "access_key", false))
  access_key_status = lookup(each.value, "access_key_status", "Active")
}

#.........................................................

output "iam_user_name" {
  value = { for k, v in module.iam_user : k => v.name}
}

output "iam_user_arn" {
  value = { for k, v in module.iam_user : k => v.arn}
}

output "iam_user_access_key" {
  value = { for k, v in module.iam_user : k => v.access_key}
}

output "iam_user_secret" {
  value = { for k, v in module.iam_user : k => v.secret}
  sensitive = true
}

output "iam_user_encrypted_secret" {
  value = { for k, v in module.iam_user : k => v.encrypted_secret}
  sensitive = true
}