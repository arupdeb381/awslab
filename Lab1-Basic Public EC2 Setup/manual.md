Objective
Understand:
  VPC
  Public subnet
  IGW
  Route table
  Public IP
  Tasks

Create:
  VPC
  1 Public subnet
  Internet Gateway
  Route table with internet route
  EC2 in public subnet
  Install Apache/Nginx.

Validation
  SSH works
  Website accessible publicly






Execution:
Create a VPC - 
    Required:
    Ipv4 CIDR - 10.0.0.0/24



    Optional:
    Name - lab01-vpc
    Tag -
    Name - lab01vpc
    Env - prod
    Customer - arup



 1 Public Subnet - 
    Required:
    VPC ID
    IPv4 subnet CIDR Block - 10.0.1.0/24
    Auto-assign public IP

    Optional:
    Subnet Name
    Availability Zone
    Tag
 
Internet Gateway - 
    Required:
    Name
    Attach to VPC.
 Route table - 
    Required:
    Select VPC
    Optional:
    Name
    Tag
Create a route - 
    Destination: 0.0.0.0/0
    Target: lab01-igw.id
Create EC2 in public subnet - 
    AMI - ami-00e801948462f718a
    Size - t3.micro
    Key-pair - server01
    VPC - select VPC
    Subnet -lab01-public-snet
    Userdata.sh

Security group - 
    Name - 
    Rule - 
    Allow ssh 
    

    
