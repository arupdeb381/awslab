Objective:
Understand:
    Secure SSH access
    Bastion concept

Tasks:
Create:
    Bastion EC2 in public subnet
    Private EC2 in private subnet

Rules:
    Internet → Bastion
    Bastion → Private EC2

Validation
SSH flow:
    Your Laptop → Bastion → Private EC2