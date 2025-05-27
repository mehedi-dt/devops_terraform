variable "source_bucket"       { type = string }
variable "destination_bucket"  { type = string }
variable "source_prefix"       { type = string }
variable "destination_prefix"  { type = string }

variable "overwrite_mode"  { type = string }
variable "preserve_deleted_files"  { type = string }
variable "verify_mode"  { type = string }
variable "posix_permissions"  { type = string }
variable "uid"  { type = string }
variable "gid"  { type = string }
variable "schedule_expression" {}


terraform {
  required_providers {
    aws = {
      configuration_aliases = [ aws.source_provider ]
    }
  }
}