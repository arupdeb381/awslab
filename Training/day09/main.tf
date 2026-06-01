resource "aws_instance" "production_instance" {
  ami           = "ami-0ff8a91507f77f867"
  #instance_type = "t3.micro"
  instance_type = "t3.micro" # Production always uses t3.micro
  region        = tolist(var.regions)[0] # Using the first region from the variable list
  count         = var.instance_count

  tags = var.tags
}

resource "aws_instance" "development_instance" {
  ami           = "ami-0ff8a91507f77f867"
  #instance_type = "t3.micro"
  instance_type = "t2.micro" # Development always uses t2.micro
  region        = tolist(var.regions)[0] # Using the first region from the variable list
  count         = var.instance_count

  tags = {
    env = "Dev"
    created_by = "Terraform"
    owner = "Arup Debnath"

  }

}

