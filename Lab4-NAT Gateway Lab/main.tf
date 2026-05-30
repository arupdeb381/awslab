terraform {
  backend "s3" {
    bucket = "arup-lab-aws-training"
    key    = "lab4/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
