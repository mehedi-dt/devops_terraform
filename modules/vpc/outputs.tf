output "id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnet_az" {
  description = "The AZs of the public subnets"
  value       = aws_subnet.public[*].availability_zone
}

output "private_subnet_az" {
  description = "The AZs of the private subnets"
  value       = aws_subnet.private[*].availability_zone
}

# output "nat_gateway_ids" {
#   description = "The IDs of the NAT gateways"
#   value       = aws_nat_gateway.vpc[*].id
#   condition   = var.create_nat_gateway
# }