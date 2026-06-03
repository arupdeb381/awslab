variable "project_name" {
    default = "project ARUP resources with Terraform"
}

variable "customer_info" {
    default = {
        owner = "Arup"
        location = "India"
    }

}
variable "role" {
    default = {
        name = "System Engineer"
        dept = "Cloud"
    }
}


variable "bucket_name" {
    default = "THIS is test - aws_s3_bucket_arup"
}


variable "allowed_ports" {
    default = "22, 80, 443, 8080"
}

variable "instance_sizes" {
    default = {
        small = "t2.micro"
        medium = "t2.small"
        large = "t2.medium"
    }
}

variable "instance_type" {
    default = "medium"
}