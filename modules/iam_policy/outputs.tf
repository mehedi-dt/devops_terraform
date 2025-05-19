output "arn" {
    description = "The ARN of the IAM policy"
    value       = aws_iam_policy.this.arn
}

output "id" {
    description = "The ARN of the IAM policy"
    value       = aws_iam_policy.this.id
}

output "policy_id" {
    description = "The ID of the IAM policy"
    value       = aws_iam_policy.this.policy_id 
}