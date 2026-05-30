
##########################
## Base config - 
########################## 
variable "tf-state" {
    default = "terraform.tfstate"
    type = string
}

variable "bucket" {
    default = "arup-lab-aws-training"
    type = string
}

variable "region" {
    default = "us-east-1"
    type = string
}

variable "env" {
    default = "lab04"
    type = string
}

##########################
## Networking config - 
##########################
variable "vpc_cidr" {
    default = "10.0.0.0/16"
    type = string
}

variable "public_subnet_cidr" {
    default = "10.0.1.0/24"
    type = string
}

variable "private_subnet_cidr" {
    default = "10.0.2.0/24"
    type = string
}

variable "my_ip" {
    default = "104.30.167.32/32"
    type = string
}

variable "all_outbound" {
    default = "0.0.0.0/0"
    type = string
}

##########################
## EC2 config - 
##########################
variable "key_name" {
    default = "server01"
    type = string
}

variable "instance_type" {
    default = "t3.micro"
    type = string
}

variable "amazon-linux-ami" {
    default = "ami-00e801948462f718a"
    type = string
}

##########################