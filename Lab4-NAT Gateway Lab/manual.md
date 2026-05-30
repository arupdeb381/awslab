Lab4-NAT Gateway Lab/
|
├── main.tf                # Main resources
├── variables.tf           # Input variables
├── outputs.tf             # Output values
├── providers.tf           # Provider configuration
├── versions.tf            # Terraform and provider version constraints
├── terraform.tfvars       # Variable values (environment specific)
├── locals.tf              # Local values


Objective
----------
Understand:
Outbound internet for private subnet

Tasks
-----------
Create:
    NAT Gateway in public subnet
    Private subnet route through NAT

Launch:
    EC2 in private subnet
    Validation

From private EC2:
    Internet should work
    yum update should work

But:
No inbound internet access