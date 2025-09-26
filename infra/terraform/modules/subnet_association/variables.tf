variable "public_subnets" {
    description = "The ID of the Public Subnet"
    type        = list(string)
}
variable "private_subnets" {
    description = "The ID of the Private Subnet"
    type        = list(string)
}
variable "public_route_table_id" {
  description = "The ID of the Public Route Table"
  type=string
}
variable "private_route_table_id" {
  description = "The ID of the Private Route Table"
  type=string
}



