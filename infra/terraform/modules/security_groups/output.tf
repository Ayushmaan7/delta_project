output "WordPressSG" {
    description = "This is the Id of Security Group for WordpressOS"
    value = aws_security_group.WordpressTf.id
}
