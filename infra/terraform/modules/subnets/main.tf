resource "aws_subnet" "ayush_vpc_subnet_1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "ayush_vpc_subnet_1a"
  }
}

resource "aws_subnet" "ayush_vpc_subnet_1b" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "ayush_vpc_subnet_1b"
  }
}

resource "aws_subnet" "ayush_vpc_subnet_1c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "ayush_vpc_subnet_1c"
  }
}

resource "aws_subnet" "ayush_vpc_subnet_1b_private" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "ayush_vpc_subnet_1b_private"
  }
}

resource "aws_subnet" "ayush_vpc_subnet_1c_private" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.12.0/24"
  availability_zone       = "ap-south-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "ayush_vpc_subnet_1c_private"
  }
}

