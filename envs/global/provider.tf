terraform {
  required_version = ">= 1.4.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2" # region where the resources will be created
  profile = "profile-name-for-aws-secret-config" # not needed if using role-based access.
}