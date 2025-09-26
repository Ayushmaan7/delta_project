
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

