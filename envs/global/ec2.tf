locals {
  ec2 = {
    "project-1-${var.env}" = {
      instance_type = "t3a.medium"
      ami = local.default.ubuntu24-ap-south-1-ami # Ubuntu Server 24.04 LTS (HVM), SSD Volume Type x86
      subnet_id = data.terraform_remote_state.global.outputs.vpc_public_subnet_ids["${var.imported_vpc}"][0]
      vol_type = "gp3"
      vol_size = 40
      eip = true
      default_user_pubkey = local.default.project-1-ec2-pubkey
      ssh_users = {"mehedi": local.default.mehedi_pubkey}
      user_data_replace_on_change = false # if true will recrete the instance for userdata.

      vpc_id = data.terraform_remote_state.global.outputs.vpc_id["${var.imported_vpc}"]
      ingress = concat (
        local.default.web_ingress,
        local.default.ssh_ingress,
      )
      egress = local.default.egress
    }
  }
}

#.........................................................

module "ec2" {
  source      = "../../modules/ec2"
  for_each    = local.ec2
  # count = each.value.instance_count

  env = lookup(each.value, "env", var.env)
  ec2_name = lookup(each.value, "name", each.key)
  ami         = lookup(each.value, "ami", var.ami_ubuntu_lts_x86_64)
  instance_type = each.value.instance_type
  sg_ids = concat([module.sg["${each.key}"].sg_id], lookup(each.value, "sg_ids", []))
  subnet_id = each.value.subnet_id
  vol_type = lookup(each.value, "vol_type", var.vol_type)
  vol_size = lookup(each.value, "vol_size", var.vol_size)
  eip = lookup(each.value, "eip", var.eip)
  termination_protection = lookup(each.value, "termination_protection", false)
  run_ansible = lookup(each.value, "run_ansible", false)
  tags = lookup(each.value, "tags", {})
  vol_tags = lookup(each.value, "vol_tags", {})
  default_user_pubkey = each.value.default_user_pubkey
  ssh_users = lookup(each.value, "ssh_users", {})
  user_data_replace_on_change = lookup(each.value, "user_data_replace_on_change", false)
}

#.........................................................

module "sg" {
  source = "../../modules/security_group"
  for_each = local.ec2

  env = lookup(each.value, "env", var.env)
  sg_name = lookup(each.value, "sg_name", "${each.key}-sg")
  vpc_id = lookup(each.value, "vpc_id", data.terraform_remote_state.global.outputs.vpc_id["${var.imported_vpc}"])
  ingress = lookup(each.value, "ingress", [])
  egress = lookup(each.value, "egress", [])
}

output "sg_id" {
  value = { for k, v in module.sg : k => v.sg_id }
}

#.........................................................

# Iterates over module.ec2 to create a map where k (instance key) maps to v.ec2_key_name (key name from the module’s output).
output "ec2_id" {
  value = { for k, v in module.ec2 : k => v.ec2_id}
}

output "ec2_public_ip" {
  value = { for k, v in module.ec2 : k => v.ec2_public_ip}
}

output "ec2_private_ip" {
  value = { for k, v in module.ec2 : k => v.ec2_private_ip}
}

output "ec2_public_dns" {
  value = { for k, v in module.ec2 : k => v.ec2_public_dns}
}

output "ec2_availability_zone" {
  value = { for k, v in module.ec2 : k => v.ec2_availability_zone}
}

output "ec2_eip" {
  value = { for k, v in module.ec2 : k => v.ec2_eip}
}

output "ec2_key_name" {
  value = { for k, v in module.ec2 : k => v.ec2_key_name}
}