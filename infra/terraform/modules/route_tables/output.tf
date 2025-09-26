output "public_route_table_id" {
  description = "Public Route Table Id"
  value = aws_route_table.routing_table.id
}
output "private_route_table_id" {
  description = "Public Route Table Id"
  value = aws_route_table.NAT-Gateway-RT.id
}
