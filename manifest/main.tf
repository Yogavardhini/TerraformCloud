#Terraform Setting Block
terraform {
  required_providers {
    aws = {
    source = "hashicorp/aws"
    version = "5.3.0"
    }
  }
  #Terraform Backend Block
terraform {
  backend "s3" {
    bucket         = "my-tf-test-bucket-001"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
}
#Local Variable Declaration Block
locals {
json_input = jsondecode(file("${var.json_file_input}"))
json_data =  jsondecode(file("${var.json_file}"))

}
#Terraform Provider Block
provider "aws" {
   region = "ap-south-1"
   access_key = local.json_data.access_key
   secret_key = local.json_data.secret_key
}

#Terraform VPC Creation Block
resource "aws_vpc" "example_vpc" {
  cidr_block = local.json_input.vpc_id  

  tags = {
    Name = "Test VPC"
  }
}
#Terraform Subnet Creation Block
resource "aws_subnet" "example_subnet" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = local.json_input.subnet_id  
  map_public_ip_on_launch = true

  tags = {
    Name = "Test Subnet"
  }
}
#Terraform EC2 Instance Creation Block
resource "aws_instance" "mytestvm" {
    count = local.json_input.count
    ami = local.json_input.ami 
    instance_type = local.json_input.instance_type
    subnet_id     = aws_subnet.example_subnet.id
    monitoring = true
    tags = {
    Name        = "${local.json_input.VMName}-${count.index}"
      }
  }
}