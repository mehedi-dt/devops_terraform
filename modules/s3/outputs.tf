output "id" {
  description = "S3 ID"
  value = aws_s3_bucket.s3.id
}

output "arn" {
  description = "S3 ARN"
  value = aws_s3_bucket.s3.arn
}