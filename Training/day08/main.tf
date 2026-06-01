resource "aws_s3_bucket" "my_bucket_set" {
    for_each = var.bucket_names_set
    bucket = each.value
  tags = local.effective_tags
}



resource "aws_instance" "ec2_instance_01" {
  count         = local.effective_config.instance_count
  ami           = var.linux_ami # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = var.allowed_vm_type[0] # Using the first allowed instance type from the variable
  key_name = "server01" # Replace with your actual key pair name
  tags = local.effective_tags
}