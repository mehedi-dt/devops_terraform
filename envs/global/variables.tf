variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "env" {
  type    = string
  default = "global"
}

variable "imported_vpc" {
  type = string
  description = "identity name of the imported vpc"
  default = "dt-1"
}

variable "core" {
  type = string
  description = "name of core which will be used to create its related resources."
}

variable "services" {
  type = string
  description = "name of services which will be used to create its related resources."
}


variable "aws_profile" {
  description = "AWS CLI profile (used only for local execution)"
  type        = string
  default     = ""
}

variable "aws_profile_apse1" {
  description = "AWS CLI profile singapore (used only for local execution)"
  type        = string
  default     = ""
}

variable "apse1" { default = "ap-southeast-1" }

variable "project_name" {
  description = "project_name"
  type = string
  default = "dt"
}

#EC2
variable "ami_ubuntu_lts_x86_64" {
  type    = string
  default = "ami-0e8d228ad90af673b"
}

variable "vol_type" {
  type = string
  default = "gp3"
}

variable "vol_size" {
  type = number
  default = 8
}

variable "create_key" {
  type = bool
  description = "if new key will be created or use an existing one (must exist)."
  default = true
}

variable "eip" {
  type = bool
  default = true
}

variable "default_user_pub_key" {
  type = string
  default = ""
}

#SG
variable "public_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
variable "vpn_ip" {
  type = string
  default = "32.120.33.112/32"
}





## S3
variable "is_public" {
  type    = bool
  default = false
}

variable "is_version" {
  type    = bool
  default = false
}

variable "is_import" {
  type    = bool
  default = false
}

# #MySQL
# variable "rds_password" {
#   type = string
#   sensitive = true
# }