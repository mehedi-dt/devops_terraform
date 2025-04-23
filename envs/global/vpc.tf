locals {
  vpc = {
    "vpc-1" = {
      name                 = "${var.env}-vpc-1"
      env                  = var.env
      vpc_cidr             = "10.2.0.0/16"
      availability_zone    = ["${var.region}a", "${var.region}b", "${var.region}c"]
      public_subnet_cidr   = ["10.2.0.0/23", "10.2.2.0/23", "10.2.4.0/23"]
      private_subnet_cidr  = ["10.2.6.0/23", "10.2.8.0/23", "10.2.10.0/23"]
      enable_dns_support   = true
      enable_dns_hostnames = true
      nat_count = 1
    }

    "vpc-2" = {
      name                 = "${var.env}-vpc-2"
      env                  = var.env
      vpc_cidr             = "10.3.0.0/16"
      availability_zone    = ["${var.region}a", "${var.region}b", "${var.region}c"]
      public_subnet_cidr   = ["10.3.0.0/23", "10.3.2.0/23", "10.3.4.0/23"]
      private_subnet_cidr  = ["10.3.6.0/23", "10.3.8.0/23", "10.3.10.0/23"]
      enable_dns_support   = true
      enable_dns_hostnames = true
      nat_count = 0
    }
    
    # .
    # .
    # vpc-n....

  }
}

module "vpc" {
  source = "../../modules/vpc"
  for_each = local.vpc

  vpc_name             = each.value.name
  env                  = each.value.env
  vpc_cidr             = each.value.vpc_cidr
  availability_zone    = each.value.availability_zone
  public_subnet_cidr   = each.value.public_subnet_cidr
  private_subnet_cidr  = each.value.private_subnet_cidr
  enable_dns_support   = each.value.enable_dns_support
  enable_dns_hostnames = each.value.enable_dns_hostnames
  nat_count = each.value.nat_count
}

output "vpc_id" {
  value = { for k, v in module.vpc : k => v.id }
}

output "vpc_public_subnet_ids" {
  value = { for k, v in module.vpc : k => v.public_subnet_ids }
}

output "vpc_private_subnet_ids" {
  value = { for k, v in module.vpc : k => v.private_subnet_ids }
}

output "vpc_private_subnet_az" {
  value = { for k, v in module.vpc : k => v.private_subnet_az }
}

output "vpc_public_subnet_az" {
  value = { for k, v in module.vpc : k => v.public_subnet_az }
}