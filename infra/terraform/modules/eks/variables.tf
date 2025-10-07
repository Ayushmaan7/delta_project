variable "region" {}
variable "cluster_name" {}
variable "vpc_id" {}
variable "private_subnet_ids" { type = list(string) }
variable "public_subnet_ids" { type = list(string) }
variable "node_instance_type" { default = "t3.micro" }
variable "desired_size" { default = 1 }
variable "max_size" { default = 1 }
variable "min_size" { default = 1 }

