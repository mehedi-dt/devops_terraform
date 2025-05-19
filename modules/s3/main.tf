# Create bucket
resource "aws_s3_bucket" "s3" {
  bucket = var.name

  tags = {
    Name = var.name
    Env = var.env
  }
}

resource "aws_s3_bucket_public_access_block" "s3_pab" {
  count = var.is_public ? 1 : 0

  bucket = aws_s3_bucket.s3.id

  block_public_acls = var.is_public
  block_public_policy = !var.is_public
  ignore_public_acls = var.is_public
  restrict_public_buckets = !var.is_public
}

resource "aws_s3_bucket_policy" "allow_public" {
  # Execute the policy creation if is_public is true and is_import is false
  count = var.is_public == true ? 1 : 0

  bucket = aws_s3_bucket.s3.id
  policy = var.bucket_policy
}

resource "aws_s3_bucket_versioning" "version" {
  count = var.is_version ? 1 : 0
  
  bucket = aws_s3_bucket.s3.id

  versioning_configuration {
    status = "Enabled"
  }
}