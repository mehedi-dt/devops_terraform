variable "name" {
  type = string
}

variable "is_import" {
  type = bool
  default = false
}

variable "is_public" {
  type = bool
  default = false
}

variable "is_version" {
  type = bool
  default = false
}

variable "env" {
  type = string
}

variable "bucket_policy" {
  type = string
}