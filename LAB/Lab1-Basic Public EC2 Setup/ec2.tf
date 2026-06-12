resource "aws_instance" "lab01-ec2-01" {
    # General
    ami           = "ami-00e801948462f718a" # us-east-1
    instance_type = "t3.micro"
    availability_zone = "us-east-1a"

    # Networking 
    vpc_security_group_ids = [aws_security_group.lab01-sg.id]
    subnet_id     = aws_subnet.lab01-snet1-1a.id
    associate_public_ip_address = true

    # access
    key_name = "server01"
    iam_instance_profile = aws_iam_instance_profile.lab01_ssm_instance_profile.name

    # userdata
    user_data = templatefile("${path.module}/userdata.sh", {
    INDEX_HTML = file("${path.module}/index.html")
    })
    user_data_replace_on_change = true

    tags = {
        Name = "lab01-ec2-instance-01"
        "Patch Group" = aws_ssm_patch_group.lab01_patch_group.patch_group
    }
}


resource "aws_instance" "lab01-ec2-02" {
    # General
    ami           = "ami-00e801948462f718a" # us-east-1
    instance_type = "t3.micro"
    availability_zone = "us-east-1b"

    # Networking 
    vpc_security_group_ids = [aws_security_group.lab01-sg.id]
    subnet_id     = aws_subnet.lab01-snet2-1b.id
    associate_public_ip_address = true

    # access
    key_name = "server01"
    iam_instance_profile = aws_iam_instance_profile.lab01_ssm_instance_profile.name

    # userdata
    user_data = templatefile("${path.module}/userdata.sh", {
    INDEX_HTML = file("${path.module}/index.html")
    })
    user_data_replace_on_change = true

    tags = {
        Name = "lab01-ec2-instance-02"
        "Patch Group" = aws_ssm_patch_group.lab01_patch_group.patch_group
    }
}

output "instance_public_ip" {
    value = aws_instance.lab01-ec2-01.public_ip
}
output "instance_public_ip_02" {
    value = aws_instance.lab01-ec2-02.public_ip
}
