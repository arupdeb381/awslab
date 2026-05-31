
# Create EC2 instaance
resource "aws_instance" "ec2_instance_01" {
  count         = var.config.instance_count
  ami           = var.linux_ami # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = var.allowed_vm_type[0] # Using the first allowed instance type from the variable
  region        = var.config.region # Using the region from the config variable
  subnet_id     = aws_subnet.day-public-subnet.id
  security_groups = [aws_security_group.day-sg.id]
  associate_public_ip_address = var.associate_public_ip
  monitoring     = var.config.monitoring
  key_name = "server01" # Replace with your actual key pair name
  tags = var.tags
}

## new

