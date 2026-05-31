variable "env" {
    default = "day"
    type = string
}

variable "region" {
    default = "us-east-1"
    type = string
}

variable "instance_count" {
    default = 1
    type = number
}
variable "monitoring" {
    default = true
    type = bool
}

variable "associate_public_ip" {
    default = true
    type = bool
}

variable "vpc_cidrs" {
    default = ["10.0.0.0/16", "10.0.1.0/24", "10.0.2.0/24"]
    type = list(string)
    description = "List of CIDR blocks for VPC and subnets"
}

variable "allowed_vm_type" {
    default = ["t3.micro", "t3.small"]
    type = list(string)
    description = "List of allowed VM instance types"
}

variable "linux_ami" {
    default = "ami-00e801948462f718a"
    type = string
    description = "AMI ID for the EC2 instance"
}

variable "regions" {
    default = ["us-east-1", "us-west-2", "eu-east-1"]
    type = set(string)
    description = "List of AWS regions"
}

variable "tags" {
    type = map(string)
    default = {
        env = "day06"
        Name = "day06-ec2_instance_name"
        created_by = "Terraform"
    }
}

variable "ingress_values" {
    type = tuple ([ number, number, string ])
    default = [22, 22, "tcp"]
}

variable "config" {
    type = object({
        env = string
        region = string
        monitoring = bool
        instance_count = number
    })
    default = {
        env = "day06"
        region = "us-east-1"
        monitoring = true
        instance_count = 1
    }

}