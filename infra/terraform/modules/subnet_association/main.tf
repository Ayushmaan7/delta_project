resource "aws_route_table_association" "a" {
  subnet_id      = var.public_subnets[0]
  route_table_id = var.public_route_table_id
}

resource "aws_route_table_association" "b" {
  subnet_id      = var.public_subnets[1]
  route_table_id = var.public_route_table_id
}

resource "aws_route_table_association" "c" {
  subnet_id      = var.public_subnets[2]
  route_table_id = var.public_route_table_id
}

resource "aws_route_table_association" "d" {
  subnet_id      = var.private_subnets[0]
  route_table_id = var.private_route_table_id
}

resource "aws_route_table_association" "e" {
  subnet_id      = var.private_subnets[1]
  route_table_id = var.private_route_table_id
}

