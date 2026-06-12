locals {
    pub_s01 = var.public_subnet_cidrs[0]
    pub_s02 = var.public_subnet_cidrs[1]
    priv_s01 = var.private_subnet_cidrs[0]
    priv_s02 = var.private_subnet_cidrs[1]
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

resource "aws_eip" "lab11_nat_eip" {
  count  = var.eip == null ? 1 : 0
  domain = "vpc"

  tags = merge(local.tags, {
    Name = "lab11-nat-eip"
  })
}


resource "aws_nat_gateway" "lab11_nat_gw" {
  allocation_id     = var.eip != null ? var.eip : aws_eip.lab11_nat_eip[0].id
  connectivity_type = "public"
  subnet_id     = aws_subnet.lab11_pub_s1.id
    tags = merge(local.tags, {
        Name = "lab11-nat-gw"
    })
}
