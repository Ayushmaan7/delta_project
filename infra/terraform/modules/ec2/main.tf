resource "aws_instance" "Demo" {
  ami           = "ami-02d26659fd82cf299"
  instance_type = var.instance_type
  key_name = "infrastructure"
  vpc_security_group_ids = [ var.security_group_Id ]
  subnet_id = var.subnet_id

  tags = {
    Name = "Demo"
  }
}
