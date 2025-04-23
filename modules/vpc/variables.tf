variable "vpc_name" {
  description = "vpc name"
  type = string
}

variable "env" {
  type = string
}

variable "vpc_cidr" {
  description = "vpc cidr"
  type = string
}

variable "availability_zone" {
  type = list(string)
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "private_subnet_cidr" {
  type = list(string)
}

variable "enable_dns_support" {
  type = bool
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "nat_count" {
  type = number
  default = 0
}