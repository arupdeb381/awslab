# Create a VPC
resource "aws_vpc" "lab01-vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "lab01-vpc"
  }

}

# Create Public Subnets in different Availability Zones (1a, 1b)
resource "aws_subnet" "lab01-snet1-1a" {
  vpc_id     = aws_vpc.lab01-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "lab01-pub-snet1-1a"
  }
}
resource "aws_subnet" "lab01-snet2-1b" {
  vpc_id     = aws_vpc.lab01-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "lab01-pub-snet2-1b"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.lab01-vpc.id

  tags = {
    Name = "lab01-igw"
  }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.lab01-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
    tags = {
        Name = "lab01-public-rt"
    }
}

resource "aws_route_table_association" "a1" {
    subnet_id = aws_subnet.lab01-snet1-1a.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "a2" {
    subnet_id = aws_subnet.lab01-snet2-1b.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "lab01-sg" {
  name        = "lab01-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.lab01-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from anywhere"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"

    }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  tags = {
    Name = "lab01-sg"
  }
}

