locals {
formatted_project_name = lower(replace(var.project_name, " ", "_"))
customer = lower(var.customer_info.owner)
role = lower(var.role.name)
new_tag = merge(var.customer_info, var.role)
fmt_bckt_nm = substr(lower(replace(replace(var.bucket_name, "-", "_"), " ", "")), 0, 63)



port_list = split(",", var.allowed_ports)

sg_rules = [for port in local.port_list : 
{
    name = "port-${port}"
    port = port
    description = "Allow inbound traffic on port ${port}"
}
]

instance_size = lookup(var.instance_sizes,var.instance_type,"medium")
}


resource "aws_s3_bucket" "project_bucket" {
    bucket = local.fmt_bckt_nm

    tags = local.new_tag
    }
