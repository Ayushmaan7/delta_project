resource "aws_security_group" "WordpressTf" {
  name        = "WordpressTf"
  description = "Allow inbound traffic to http and outbound traffic to all"
  vpc_id      = var.vpc_id

  tags = {
    Name = "WordpressTf"
  }
}

resource "aws_vpc_security_group_egress_rule" "Wp_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.WordpressTf.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_ingress_rule" "Wp_http_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.WordpressTf.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
} 

resource "aws_vpc_security_group_ingress_rule" "Wp_ssh_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.WordpressTf.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "Wp_http_allow_all_traffic_ipv4_jenkins" {
  security_group_id = aws_security_group.WordpressTf.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

