output "nat_gateway_id" {
    description = "The ID of Internet Gateway"
    value=aws_nat_gateway.privateNat.id
  
}
