# Create a public subnet
# Create a VPC
resource "aws_vpc" "day-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    env = var.env
    Name = local.vpc_name
  }
}


resource "aws_subnet" "day-public-subnet" {
  vpc_id            = aws_vpc.day-vpc.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    env = var.env
    Name = local.pub_snet
  }
}

resource "aws_internet_gateway" "day-igw" {
  vpc_id = aws_vpc.day-vpc.id
  tags = {
    env = var.env
    Name = local.igw_name
  }
}

resource "aws_route_table" "day-public-rt" {
  vpc_id = aws_vpc.day-vpc.id
  tags = {
    env = var.env
    Name = local.pub_rt_name
  }
}

resource "aws_route" "day-public-route" {
  route_table_id         = aws_route_table.day-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.day-igw.id
}

resource "aws_route_table_association" "day-public-rt-association" {
  subnet_id      = aws_subnet.day-public-subnet.id
  route_table_id = aws_route_table.day-public-rt.id
}

resource "aws_security_group" "day-sg" {
  name        = local.sg_name
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.day-vpc.id

  ingress {
    from_port   = var.ingress_values[0]
    to_port     = var.ingress_values[1]
    protocol    = var.ingress_values[2]
    cidr_blocks = [var.vpc_cidrs[0], var.vpc_cidrs[2]]
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