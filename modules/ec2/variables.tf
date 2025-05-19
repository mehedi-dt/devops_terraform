variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "ec2_name" {
  type = string
}

variable "env" {
  type = string
}

variable "termination_protection" {
  type = bool
  default = false
}

variable "tags" {
  type = map(string)
  default = {}
}

#EBS
variable "vol_size" {
  type = number
}

variable "vol_type" {
  type = string
  default = "gp3"
}

variable "vol_tags" {
  type = map(string)
  default = {}
}

##EIP
variable "eip" {
  type = bool
}

##SG
variable "sg_ids" {
  type = list(string)
}

##Ansible
variable "run_ansible" {
  type = bool
}

##Users
variable "default_user_pubkey" {
  type = string
}

variable "ssh_users" {
  type = map(string)
}

variable "user_data_replace_on_change" {
  type = bool
  default = false
}

## SG
# variable "ingress" {
#   type = list(map(string))
# }

# variable "egress" {
#   type = list(map(string))
# }

# variable "vpc_id" {
#   type = string
# }