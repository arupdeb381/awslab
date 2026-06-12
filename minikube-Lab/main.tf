# Provider configuration for AWS
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

# Backend configuration for Terraform state
terraform {
  backend "s3" {
    bucket = "arup-lab-aws-training"
    key    = "minikube/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}

# tags for all resources

variable "tags" {
  type = map(string)
  default = {
    Environment = "Lab"
    Project     = "MiniKube"
    Owner       = "Arup"
  }
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to the private key used to connect to EC2 for post-bootstrap checks"
  default     = "../LAB/Lab3-Bastion Host Architecture/server01.pem"
}

# VPC configuration
resource "aws_vpc" "minikube_vpc" {
  cidr_block = "10.0.0.0/16"
  tags       = var.tags
}

# Subnet configuration
resource "aws_subnet" "minikube_subnet" {
  vpc_id            = aws_vpc.minikube_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1a"
  tags              = var.tags
}

# Internet Gateway configuration
resource "aws_internet_gateway" "minikube_igw" {
  vpc_id = aws_vpc.minikube_vpc.id
  tags   = var.tags
}

# Route Table configuration
resource "aws_route_table" "minikube_route_table" {
  vpc_id = aws_vpc.minikube_vpc.id
  tags   = var.tags
}

# Route configuration to allow internet access
resource "aws_route" "minikube_route" {
  route_table_id         = aws_route_table.minikube_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.minikube_igw.id
}

# Associate the route table with the subnet
resource "aws_route_table_association" "minikube_route_table_association" {
  subnet_id      = aws_subnet.minikube_subnet.id
  route_table_id = aws_route_table.minikube_route_table.id
}

# Security Group configuration
resource "aws_security_group" "sg_minikube" {
    name        = "minikube-sg"
    description = "Security group for MiniKube lab"
    vpc_id      = aws_vpc.minikube_vpc.id
    tags        = merge(
        var.tags,
        {
            Name = "minikube-sg"
        }
    ) # Merge default tags with a specific Name tag for the security group
    
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["104.30.167.32/32"] # Allow SSH from Arup's IP
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# EC2 Instance configuration for MiniKube
resource "aws_instance" "minikube_instance" {
    ami           = "ami-0c94855ba95c71c99" # Amazon Linux 2 AMI
    instance_type = "t2.medium"
    subnet_id     = aws_subnet.minikube_subnet.id
    vpc_security_group_ids = [aws_security_group.sg_minikube.id]
    tags          = var.tags
    associate_public_ip_address = true
    key_name = "server01" # Replace with your actual key pair name
    user_data = file("${path.module}/install-minikube.sh") # Script to install MiniKube on the EC2 instance
    user_data_replace_on_change = true

    # Block terraform apply until cloud-init (user_data) has finished.
    provisioner "remote-exec" {
      inline = [
        "sudo bash -lc 'while true; do status=$(cloud-init status | head -n1 | cut -d\" \" -f2); if [ \"$status\" = \"done\" ]; then echo \"cloud-init completed.\"; break; fi; if [ \"$status\" = \"error\" ]; then echo \"cloud-init failed.\"; cloud-init status --long; exit 1; fi; echo \"cloud-init in progress....\"; sleep 5; done'",
        "grep -q 'Installation Complete' /home/ec2-user/minikube-install.log"
      ]
    }

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file(var.ssh_private_key_path)
      timeout     = "45m"
    }
}

# Output the public IP of the EC2 instance
output "minikube_instance_public_ip" {
  value = aws_instance.minikube_instance.public_ip
}
