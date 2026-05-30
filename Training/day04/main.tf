terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "day04-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "day04-vpc"
  }
}

# Create a public subnet
resource "aws_subnet" "day04-public-subnet" {
  vpc_id            = aws_vpc.day04-vpc.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "day04-public-subnet"
  }
}

resource "aws_subnet" "day04-private-subnet" {
  vpc_id            = aws_vpc.day04-vpc.id
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "day04-private-subnet"
  }
}
resource "aws_internet_gateway" "day04-igw" {
  vpc_id = aws_vpc.day04-vpc.id
  tags = {
    Name = "day04-igw"
  }
}

resource "aws_route_table" "day04-public-rt" {
  vpc_id = aws_vpc.day04-vpc.id
  tags = {
    Name = "day04-public-rt"
  }
}

resource "aws_route" "day04-public-route" {
  route_table_id         = aws_route_table.day04-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.day04-igw.id
}

resource "aws_route_table_association" "day04-public-rt-association" {
  subnet_id      = aws_subnet.day04-public-subnet.id
  route_table_id = aws_route_table.day04-public-rt.id
}

resource "aws_security_group" "day04-sg" {
  name        = "day04-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.day04-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
}

# Create EC2 instaance
resource "aws_instance" "public_ec2_instance" {
  ami           = "ami-00e801948462f718a" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.day04-public-subnet.id
  security_groups = [aws_security_group.day04-sg.id]
  associate_public_ip_address = true
  key_name = "server01" # Replace with your actual key pair name
  tags = {
    Name = "PublicEC2Instance"
  }
}

# Output the public IP of the public EC2 instance
output "public_ec2_instance_public_ip" {
  value = aws_instance.public_ec2_instance.public_ip
}
