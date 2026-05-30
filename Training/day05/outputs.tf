output "public_instance_public_ip" {
  value = aws_instance.lab04-pub-instance.public_ip
}

output "private_instance_private_ip" {
  value = aws_instance.lab04-pvt-instance.private_ip
}
