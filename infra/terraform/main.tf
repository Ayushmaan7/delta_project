module "vpc" {
  source        = "./modules/vpc"
  aws_vpc_cidr = var.aws_vpc_cidr
}

module "subnets" {
  source = "./modules/subnets"
  vpc_id = module.vpc.vpc_id  # Pass the VPC ID to the subnets module
}

module "internet_gateway" {
  source = "./modules/internet_gateway"
  vpc_id = module.vpc.vpc_id  # Pass the VPC ID to the subnets module
}
module "nat_gateway" {
  source = "./modules/nat_gateway"
  subnet_id= module.subnets.public_subnets[0] # Pass the subnet ID to the nat gateway module
}
module "route_tables" {
  source = "./modules/route_tables"
  vpc_id = module.vpc.vpc_id
  nat_gateway_id = module.nat_gateway.nat_gateway_id
  internet_gateway_id = module.internet_gateway.internet_gateway_id
}
module "subnet_association" {
  source = "./modules/subnet_association"
  public_subnets = module.subnets.public_subnets
  private_subnets = module.subnets.private_subnets
  public_route_table_id = module.route_tables.public_route_table_id
  private_route_table_id = module.route_tables.private_route_table_id
}
module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}
module "ec2" {
  source = "./modules/ec2"
  subnet_id = module.subnets.public_subnets[0]
  security_group_Id = module.security_groups.WordPressSG
  instance_type = var.instance_type
}
