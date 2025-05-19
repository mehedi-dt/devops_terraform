variable "name" {
  description = "The name of the IAM policy"
  type = string
}

variable "policy" {
  type = string
}

variable "access_key" {
  type = bool
}

variable "access_key_status" {
  type = string
}