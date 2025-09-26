output "Ip" {
  description = "IP of Wordpress Instance"
  value = "Wordpress is running on: ${module.ec2.Ip}"
}

