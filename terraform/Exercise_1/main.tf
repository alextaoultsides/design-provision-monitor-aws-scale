# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = "accesskey"
  secret_key = "secretkey"
  region = "us-east-1"
}

variable "subnet_public" {
  description = "Private Subnet 1"
  default = "subnet-0a3b1cc30daca9ac0"
}
# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2

resource "aws_instance" "Udacity_T2" {
  
  count = "4"
  subnet_id = var.subnet_public
  ami = "ami-0c6b1d09930fac512"
  instance_type = "t2.micro"

  tags = {
    Name  = "Udacity T2"
    
  }
}


# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "Udacity_M4" {
  
  count = "0"
  subnet_id = var.subnet_public
  ami = "ami-0c6b1d09930fac512"
  instance_type = "m4.large"


  tags = {
    Name  = "Udacity M4"
  }
}