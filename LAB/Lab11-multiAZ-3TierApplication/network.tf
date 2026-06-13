locals {
    pub_s01 = var.public_subnet_cidrs[0]
    pub_s02 = var.public_subnet_cidrs[1]
    priv_s01 = var.private_subnet_cidrs[0]
    priv_s02 = var.private_subnet_cidrs[1]
    db_s01 = var.db_subnet_cidrs[0]
    db_s02 = var.db_subnet_cidrs[1]
    tags = var.tags
    vpc_cidr = var.vpc_cidr


}

resource "aws_vpc" "lab11_vpc" {
  cidr_block = local.vpc_cidr
    tags = merge(local.tags, {
        Name = "lab11-vpc"
    })
}

resource "aws_subnet" "lab11_pub_s1" {
  vpc_id            = aws_vpc.lab11_vpc.id
  cidr_block        = local.pub_s01
  availability_zone = var.availability_zones[0]
    tags = merge(local.tags, {
        Name = "lab11-pub-s1-1a"
    })
}

resource "aws_subnet" "lab11_pub_s2" {
  vpc_id            = aws_vpc.lab11_vpc.id
  cidr_block        = local.pub_s02
  availability_zone = var.availability_zones[1]
    tags = merge(local.tags, {
        Name = "lab11-pub-s2-1b"
    })
}

resource "aws_subnet" "lab11_priv_s1" {
  vpc_id            = aws_vpc.lab11_vpc.id
  cidr_block        = local.priv_s01
  availability_zone = var.availability_zones[0]
    tags = merge(local.tags, {
        Name = "lab11-priv-s1-1a"
    })
}

resource "aws_subnet" "lab11_priv_s2" {
  vpc_id            = aws_vpc.lab11_vpc.id
  cidr_block        = local.priv_s02
  availability_zone = var.availability_zones[1]
    tags = merge(local.tags, {
        Name = "lab11-priv-s2-1b"
    })
}

resource "aws_subnet" "lab11_db_s1" {
  vpc_id            = aws_vpc.lab11_vpc.id
  cidr_block        = local.db_s01
  availability_zone = var.availability_zones[0]
    tags = merge(local.tags, {
        Name = "lab11-db-s1-1a"
    })
}

resource "aws_subnet" "lab11_db_s2" {
  vpc_id            = aws_vpc.lab11_vpc.id
  cidr_block        = local.db_s02
  availability_zone = var.availability_zones[1]
    tags = merge(local.tags, {
        Name = "lab11-db-s2-1b"
    })
}

resource "aws_internet_gateway" "lab11_igw" {
  vpc_id = aws_vpc.lab11_vpc.id
    tags = merge(local.tags, {
        Name = "lab11-igw"
    })
}
resource "aws_route_table" "lab11_public_rt" {
  vpc_id = aws_vpc.lab11_vpc.id
    tags = merge(local.tags, {
        Name = "lab11-public-rt"
    })
}

resource "aws_route_table_association" "lab11_public_rt_assoc_s1" {
  subnet_id      = aws_subnet.lab11_pub_s1.id
  route_table_id = aws_route_table.lab11_public_rt.id
}

resource "aws_route_table_association" "lab11_public_rt_assoc_s2" {
  subnet_id      = aws_subnet.lab11_pub_s2.id
  route_table_id = aws_route_table.lab11_public_rt.id
}

resource "aws_route" "lab11_public_rt_default_route" {
  route_table_id         = aws_route_table.lab11_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lab11_igw.id
}

resource "aws_eip" "lab11_nat_eip_pub_s1" {
  domain = "vpc"
    tags = merge(local.tags, {
        Name = "lab11-nat-eip-pub-s1"
    })
}

resource "aws_eip" "lab11_nat_eip_pub_s2" {
  domain = "vpc"
    tags = merge(local.tags, {
        Name = "lab11-nat-eip-pub-s2"
    })
}
resource "aws_nat_gateway" "lab11_nat_gw_s1" {
  allocation_id = aws_eip.lab11_nat_eip_pub_s1.id
  subnet_id     = aws_subnet.lab11_pub_s1.id
    tags = merge(local.tags, {
        Name = "lab11-nat-gw-s1"
    })
}

resource "aws_route_table" "lab11_private_rt_s1" {
  vpc_id = aws_vpc.lab11_vpc.id
    tags = merge(local.tags, {
        Name = "lab11-private-rt-s1"
    })
}

resource "aws_route_table_association" "lab11_private_rt_assoc_s1" {
  subnet_id      = aws_subnet.lab11_priv_s1.id
  route_table_id = aws_route_table.lab11_private_rt_s1.id
}


resource "aws_nat_gateway" "lab11_nat_gw_s2" {
  allocation_id = aws_eip.lab11_nat_eip_pub_s2.id
  subnet_id     = aws_subnet.lab11_pub_s2.id
    tags = merge(local.tags, {
        Name = "lab11-nat-gw-s2"
    })
}

resource "aws_route_table" "lab11_private_rt_s2" {
  vpc_id = aws_vpc.lab11_vpc.id
    tags = merge(local.tags, {
        Name = "lab11-private-rt-s2"
    })
}

resource "aws_route_table_association" "lab11_private_rt_assoc_s2" {
  subnet_id      = aws_subnet.lab11_priv_s2.id
  route_table_id = aws_route_table.lab11_private_rt_s2.id
}

resource "aws_route" "lab11_private_rt_s1_default_route" {
  route_table_id         = aws_route_table.lab11_private_rt_s1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.lab11_nat_gw_s1.id
}

resource "aws_route" "lab11_private_rt_s2_default_route" {
  route_table_id         = aws_route_table.lab11_private_rt_s2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.lab11_nat_gw_s2.id
}


resource "aws_security_group" "lab11_loadbalancer_sg" {
  name        = "lab11-loadbalancer-sg"
  description = "Security group for load balancers"
  vpc_id      = aws_vpc.lab11_vpc.id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "lab11-loadbalancer-sg"
})
}  

resource "aws_security_group" "lab11_web_sg" {
  name        = "lab11-web-sg"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.lab11_vpc.id

  ingress {
    description     = "Allow HTTP from load balancer SG"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lab11_loadbalancer_sg.id]

    }

  ingress {
    description     = "Allow HTTP from MyIP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["104.30.167.32/32"]
    }
  tags = merge(local.tags, {
    Name = "lab11-web-sg"
  })
}

resource "aws_security_group" "lab11_app_sg" {
  name        = "lab11-app-sg"
  description = "Security group for application servers"
  vpc_id      = aws_vpc.lab11_vpc.id

  ingress {
    description     = "Allow HTTP from web server SG"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lab11_web_sg.id]
  }
tags = merge(local.tags, {
    Name = "lab11-app-sg"
  })
}

