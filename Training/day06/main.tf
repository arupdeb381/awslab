
# Create EC2 instaance
resource "aws_instance" "ec2_instance_01" {
  count         = var.instance_count
  ami           = "ami-00e801948462f718a" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"
  region        = var.region
  subnet_id     = aws_subnet.day-public-subnet.id
  security_groups = [aws_security_group.day-sg.id]
  associate_public_ip_address = var.associate_public_ip
  monitoring     = var.monitoring
  key_name = "server01" # Replace with your actual key pair name
  tags = {
    env = var.env
    Name = local.ec2_instance_name
  }
}


