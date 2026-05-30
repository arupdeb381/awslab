resource "aws_vpc" "lab04-vpc" {
  cidr_block = "${var.vpc_cidr}"

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_subnet" "lab04-pub-subnet" {
  vpc_id     = aws_vpc.lab04-vpc.id
  cidr_block = "${var.public_subnet_cidr}"

  tags = {
    Name = "${var.env}-pub-subnet"
  }
}

resource "aws_subnet" "lab04-pvt-subnet" {
  vpc_id     = aws_vpc.lab04-vpc.id
  cidr_block = "${var.private_subnet_cidr}"

  tags = {
    Name = "${var.env}-pvt-subnet"
  }
}

resource "aws_internet_gateway" "lab04-igw" {
  vpc_id = aws_vpc.lab04-vpc.id

  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_route_table" "lab04-rt" {
  vpc_id = aws_vpc.lab04-vpc.id
    tags = {
        Name = "${var.env}-rt"
    }
}

resource "aws_route" "lab04-internet-route" {
    route_table_id         = aws_route_table.lab04-rt.id
    destination_cidr_block = "${var.all_outbound}"
    gateway_id             = aws_internet_gateway.lab04-igw.id
}

resource "aws_route_table_association" "lab04-pub-subnet-association" {
  subnet_id      = aws_subnet.lab04-pub-subnet.id
  route_table_id = aws_route_table.lab04-rt.id
}

resource "aws_security_group" "lab04-sg" {
  name        = "${var.env}-sg"
  description = "Allow SSH and ICMP traffic from the public subnet only"
  vpc_id      = aws_vpc.lab04-vpc.id

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
