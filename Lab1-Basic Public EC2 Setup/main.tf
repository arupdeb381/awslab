# -----------------------------------------------------------------------------
# Terraform Backend Configuration
# Stores terraform.tfstate remotely in existing S3 bucket
# -----------------------------------------------------------------------------
terraform {
  backend "s3" {
    bucket = "arup-lab1-basic-public-ec2-setup"
    key    = "lab1/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
  
  # Required Terraform Providers
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}