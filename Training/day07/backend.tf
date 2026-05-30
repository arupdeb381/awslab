terraform {
  backend "s3" {
    bucket = "arup-lab-aws-training"
    key    = "day06/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}
