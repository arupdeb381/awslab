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
resource "aws_vpc" "lab02-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "lab02-vpc"
  }

}

# Create a public subnet
resource "aws_subnet" "lab02-public-subnet" {
  vpc_id            = aws_vpc.lab02-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "lab02-public-subnet"
  }
}

# Create a private subnet
resource "aws_subnet" "lab02-private-subnet" {
  vpc_id            = aws_vpc.lab02-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "lab02-private-subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "lab02-igw" {
  vpc_id = aws_vpc.lab02-vpc.id

  tags = {
    Name = "lab02-igw"
  }
}

# Create a route table for the public subnet
resource "aws_route_table" "lab02-public-rt" {
  vpc_id = aws_vpc.lab02-vpc.id

  tags = {
    Name = "lab02-public-rt"
  }
}

# Create a route to the Internet Gateway
resource "aws_route" "lab02-public-route" {
  route_table_id         = aws_route_table.lab02-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lab02-igw.id
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "lab02-public-subnet-association" {
  subnet_id      = aws_subnet.lab02-public-subnet.id
  route_table_id = aws_route_table.lab02-public-rt.id
}



resource "aws_security_group" "lab02-public-sg" {
  name        = "lab02-public-sg"
  description = "Allow SSH and HTTP access"
  vpc_id      = aws_vpc.lab02-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_security_group" "lab02-private-sg" {
  name        = "lab02-private-sg"
  description = "Allow internal access"
  vpc_id      = aws_vpc.lab02-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.lab02-vpc.cidr_block]
  }
}
