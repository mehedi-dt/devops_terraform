terraform {
  required_version = ">= 1.4.0"
  
  # for using aws s3 for backend
  backend "s3" {
    bucket         = "bucket-name"
    key            = "envs/global/terraform.tfstate"
    region         = "eu-west-2" # region where the bucket is
    dynamodb_table = "dynamodb-table-for-locking" # create a table with a Partition Key: LockID (type: String)
    encrypt        = true
    profile        = "profile-name-for-aws-secret-config" # not needed if using role-based access.
  }
}