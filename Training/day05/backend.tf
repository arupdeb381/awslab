terraform {
  backend "s3" {
    bucket = "arup-lab-aws-training"
    key    = "day05/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}
