output "name" {
  description = "The name of the IAM role"
  value       = aws_iam_user.this.name
}

output "arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_user.this.arn
}

output "access_key" {
  value = length(aws_iam_access_key.this) > 0 ? aws_iam_access_key.this[0].id : null
}

output "encrypted_secret" {
  value     = length(aws_iam_access_key.this) > 0 ? aws_iam_access_key.this[0].encrypted_secret : null
  sensitive = true
}

output "secret" {
  value     = length(aws_iam_access_key.this) > 0 ? aws_iam_access_key.this[0].secret : null
  sensitive = true
}