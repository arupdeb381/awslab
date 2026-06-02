locals {
formatted_project_name = lower(replace(var.project_name, " ", "_"))
customer = lower(var.customer_name)
role = lower(var.role)
}

resource "aws_s3_bucket" "project_bucket" {
    bucket = "${local.customer}_${local.role}_bucket"

    tags = {
        project = local.formatted_project_name
        customer = local.customer
        role = local.role
    }
}
