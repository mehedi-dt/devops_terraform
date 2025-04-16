variable "sg_name" {
  type = string
}

variable "sg_description" {
  type = string
  default = ""
}

# variable "ingress" {
#   type = list(map(string))
# }

# variable "egress" {
#   type = list(map(string))
# }

variable "vpc_id" {
  type = string
}

variable "env" {
  type = string
  default = ""
}

variable "ingress" {
  type = list(object({
    from_port = number
    to_port = number
    protocol = string
    cidr_block = optional(string, null)
    sg_id = optional(string, null)
  }))
}

variable "egress" {
  type = list(object({
    from_port = number
    to_port = number
    protocol = string
    cidr_block = optional(string, null)
    sg_id = optional(string, null)
  }))
}