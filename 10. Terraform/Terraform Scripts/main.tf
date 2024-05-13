
provider "aws" {
    region = "ap-south-1"
}


resource "aws_vpc" "vpc-1" {
  cidr_block = "10.0.0.0/16"

tags = {
    Name = "vpc-1"
  }
}

resource "aws_subnet" "sub-1" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.0.1.0/24"

tags = {
    Name = "sub-1"
  }

}


data "aws_vpc" "existing_vpc" {
  default = true
}

resource "aws_subnet" "sub-2" {
  vpc_id     = data.aws_vpc.existing_vpc.id
  cidr_block = "172.31.48.0/20"

tags = {
    Name = "sub-2"
  }

}

resource "aws_instance" "ec2_instance" {
    ami = "${var.ami_id}"
    count = "${var.number_of_instances}"
    subnet_id = "${var.subnet_id}"
    instance_type = "${var.instance_type}"
    key_name = "${var.ami_key_pair_name}"
	
	tags = {
    Name = "${var.resource_tags}"
  }
}

output "my_vpc_output" {
value = aws_vpc.vpc-1.id
}

output "my_subnet_output" {
value = aws_subnet.sub-1.id
}
