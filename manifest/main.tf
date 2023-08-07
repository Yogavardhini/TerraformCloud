#Terraform Setting Block
terraform {
  required_providers {
    aws = {
    source = "hashicorp/aws"
    version = "5.3.0"
    }
  }

#Terraform VPC Creation Block
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Test VPC"
  }
}
#Terraform Subnet Creation Block
resource "aws_subnet" "example_subnet" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = aws_vpc.example_vpc.cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = "Test Subnet"
  }
}
#Terraform EC2 Instance Creation Block
resource "aws_instance" "mytestvm" {
    ami = "ami-0b7acb262cc9ea2ea"
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.example_subnet.id
    monitoring = true
    tags = {
    Name        = " Test VM "
      }
  }
}