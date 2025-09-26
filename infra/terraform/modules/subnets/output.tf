output "public_subnets" {
  description = "List of public subnet IDs"
  value       = [
    aws_subnet.ayush_vpc_subnet_1a.id,
    aws_subnet.ayush_vpc_subnet_1b.id,
    aws_subnet.ayush_vpc_subnet_1c.id,
  ]
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = [
    aws_subnet.ayush_vpc_subnet_1b_private.id,
    aws_subnet.ayush_vpc_subnet_1c_private.id,
  ]
}

