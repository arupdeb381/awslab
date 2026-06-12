variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    Environment = "Lab11"
    Project     = "MultiAZ-3TierApplication"
    Owner       = "Arup.Debnath"
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones to deploy resources"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "eip" {
  description = "EIP allocation for NAT Gateway"
  type        = string
  default     = null
  nullable    = true
}

