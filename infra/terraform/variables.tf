
variable "aws_vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}


variable "aws_region" {
  description = "Aws region for this project"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "Instance Type for WordpressOS"
  type        = string
  default     = "t2.micro"
}

variable "region" {}
variable "cluster_name" {}
variable "node_instance_type" { default = "t3.micro" }
variable "desired_size" { default = 1 }
variable "max_size" { default = 2 }
variable "min_size" { default = 1 }

