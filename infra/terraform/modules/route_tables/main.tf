resource "aws_route_table" "routing_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name = "Routing-Table"
  }
}
resource "aws_route_table" "NAT-Gateway-RT" {
  

  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

  tags = {
    Name = "Route Table for NAT Gateway"
  }

}
