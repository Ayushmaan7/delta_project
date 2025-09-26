resource "aws_nat_gateway" "privateNat" {
  connectivity_type = "private"
  subnet_id         = var.subnet_id
}
