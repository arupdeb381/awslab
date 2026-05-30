resource "aws_vpc" "lab03-vpc" {
  cidr_block = "${var.vpc_cidr}"

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_subnet" "lab03-pub-subnet" {
  vpc_id     = aws_vpc.lab03-vpc.id
  cidr_block = "${var.public_subnet_cidr}"

  tags = {
    Name = "${var.env}-pub-subnet"
  }
}

resource "aws_subnet" "lab03-pvt-subnet" {
  vpc_id     = aws_vpc.lab03-vpc.id
  cidr_block = "${var.private_subnet_cidr}"

  tags = {
    Name = "${var.env}-pvt-subnet"
  }
}

resource "aws_internet_gateway" "lab03-igw" {
  vpc_id = aws_vpc.lab03-vpc.id

  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_route_table" "lab03-rt" {
  vpc_id = aws_vpc.lab03-vpc.id
    tags = {
        Name = "${var.env}-rt"
    }
}

resource "aws_route" "lab03-internet-route" {
    route_table_id         = aws_route_table.lab03-rt.id
    destination_cidr_block = "${var.all_outbound}"
    gateway_id             = aws_internet_gateway.lab03-igw.id
}

resource "aws_route_table_association" "lab03-pub-subnet-association" {
  subnet_id      = aws_subnet.lab03-pub-subnet.id
  route_table_id = aws_route_table.lab03-rt.id
}

resource "aws_security_group" "lab03-sg" {
  name        = "${var.env}-sg"
  description = "Allow SSH and ICMP traffic from the public subnet only"
  vpc_id      = aws_vpc.lab03-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.all_outbound}"]
  }

    tags = {
        Name = "${var.env}-sg"
    }

}
