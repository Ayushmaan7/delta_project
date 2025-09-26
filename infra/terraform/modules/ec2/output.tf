output "Ip" {
    description = "Ip Of Wordpress OS"
    value = aws_instance.Demo.public_ip
}
