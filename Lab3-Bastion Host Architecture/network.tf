resource "aws_vpc" "lab03-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "lab03-vpc"
  }
}

resource "aws_subnet" "lab03-pub-subnet" {
  vpc_id     = aws_vpc.lab03-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "lab03-pub-subnet"
  }
}

resource "aws_subnet" "lab03-pvt-subnet" {
  vpc_id     = aws_vpc.lab03-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "lab03-pvt-subnet"
  }
}

resource "aws_internet_gateway" "lab03-igw" {
  vpc_id = aws_vpc.lab03-vpc.id

  tags = {
    Name = "lab03-igw"
  }
}

resource "aws_route_table" "lab03-rt" {
  vpc_id = aws_vpc.lab03-vpc.id
    tags = {
        Name = "lab03-rt"
    }
}

resource "aws_route" "lab02-internet-route" {
    route_table_id         = aws_route_table.lab03-rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.lab03-igw.id
}

resource "aws_route_table_association" "lab03-pub-subnet-association" {
  subnet_id      = aws_subnet.lab03-pub-subnet.id
  route_table_id = aws_route_table.lab03-rt.id
}

resource "aws_security_group" "lab03-sg" {
  name        = "lab03-sg"
  description = "Allow SSH and ICMP traffic from the public subnet only"
  vpc_id      = aws_vpc.lab03-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["104.30.167.32/32"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
        Name = "lab03-sg"
    }

}
