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

variable "key_name" {
  type = string
}

variable "create_key" {
  type = bool
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