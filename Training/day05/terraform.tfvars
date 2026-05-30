# Create security group for public EC2 instance

resource "aws_instance" "public_ec2_instance" {
  ami           = "ami-00e801948462f718a" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.lab02-public-subnet.id
  security_groups = [aws_security_group.lab02-public-sg.id]
  associate_public_ip_address = true
  key_name = "server01" # Replace with your actual key pair name
  tags = {
    Name = "PublicEC2Instance"
  }
}

resource "aws_instance" "private_ec2_instance" {
  ami           = "ami-00e801948462f718a" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.lab02-private-subnet.id
  security_groups = [aws_security_group.lab02-private-sg.id]
  associate_public_ip_address = false
  key_name = "server01" # Replace with your actual key pair name
  tags = {
    Name = "PrivateEC2Instance"
  }
}
