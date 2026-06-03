output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_public_a_id" {
  description = "ID of public subnet in AZ a"
  value       = aws_subnet.public_a.id
}

output "subnet_public_b_id" {
  description = "ID of public subnet in AZ b"
  value       = aws_subnet.public_b.id
}

output "subnet_public_c_id" {
  description = "ID of public subnet in AZ c"
  value       = aws_subnet.public_c.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}
