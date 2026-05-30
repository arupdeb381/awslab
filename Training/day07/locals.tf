locals {
  env = var.env
  bucket_name = "training-arup-${local.env}"
  vpc_name = "${var.env}-vpc"
  pub_snet = "${var.env}-public-subnet"
  pvt_snet = "${var.env}-private-subnet"
  igw_name = "${var.env}-igw"
  pub_rt_name = "${var.env}-public-rt"
  sg_name = "${var.env}-sg"
  ec2_instance_name = "${var.env}-ec2-instance"
  
}