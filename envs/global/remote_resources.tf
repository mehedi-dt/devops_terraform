# Data source to fetch VPC information from the global state
data "terraform_remote_state" "global" {
  backend = "s3"

  config = {
    bucket         = "bucket-name"
    key            = "envs/global/terraform.tfstate"
    region  = var.region
    
    # profile will be set via variable only when running locally
    profile = var.aws_profile != "" ? var.aws_profile : null
  }
}