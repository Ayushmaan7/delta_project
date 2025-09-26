resource "aws_instance" "Demo" {
  ami           = "ami-0888ba30fd446b771"
  instance_type = var.instance_type
  key_name = "infrastructure"
  vpc_security_group_ids = [ var.security_group_Id ]
  subnet_id = var.subnet_id

  tags = {
    Name = "Demo"
  }
}
