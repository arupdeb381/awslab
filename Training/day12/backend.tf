terraform {
  backend "s3" {
    bucket = "arup-lab-aws-training"
    key    = "day12/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}
