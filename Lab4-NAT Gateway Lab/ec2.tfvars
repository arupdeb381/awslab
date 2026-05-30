resource "aws_instance" "lab04-pub-instance" {
  ami           = "ami-00e801948462f718a" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.lab04-pub-subnet.id
  security_groups = [aws_security_group.lab04-sg.id]
  associate_public_ip_address = true
  key_name = "server01" # Replace with your actual key pair name
  
  user_data = templatefile("${path.module}/userdata.sh", {
    PEM_FILE = file("${path.module}/server01.pem")
  })
  
  tags = {
    Name = "PublicEC2Instance"
  }
}

resource "aws_instance" "lab04-pvt-instance" {
  ami           = "ami-00e801948462f718a" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.lab04-pvt-subnet.id
  security_groups = [aws_security_group.lab04-sg.id]
  key_name = "server01" # Replace with your actual key pair name
  tags = {
    Name = "PrivateEC2Instance"
  }
}


output "public_instance_public_ip" {
  value = aws_instance.lab04-pub-instance.public_ip
}

output "private_instance_private_ip" {
  value = aws_instance.lab04-pvt-instance.private_ip
}
