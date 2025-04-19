output "ec2_id" {
  description = "EC2 ID"
  value = aws_instance.ec2.id
}

output "ec2_public_ip" {
  description = "EC2 Public IP"
  value = aws_instance.ec2.public_ip
}

output "ec2_private_ip" {
  description = "EC2 Private IP"
  value = aws_instance.ec2.private_ip
}

output "ec2_public_dns" {
  description = "The public DNS name of the EC2 instance"
  value       = aws_instance.ec2.public_dns
}

output "ec2_availability_zone" {
  description = "The availability zone of the EC2 instance"
  value       = aws_instance.ec2.availability_zone
}

output "ec2_instance_type" {
  description = "The type of the EC2 instance"
  value       = aws_instance.ec2.instance_type
}

output "ec2_key_name" {
  description = "The name of the key pair associated with the EC2 instance"
  value       = aws_instance.ec2.key_name
}

output "ec2_eip" {
  value = try(aws_eip.eip[0].public_ip, null) # Use `try()` to handle cases where the EIP does not exist
}