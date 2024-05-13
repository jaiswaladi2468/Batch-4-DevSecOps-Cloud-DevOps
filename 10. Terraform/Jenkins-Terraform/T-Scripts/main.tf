provider "aws" {
  region = "ap-south-1"
  access_key= "XXXXXXXXXXXXXXX"
  secret_key= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  
  
}

variable vpc_cidr_block {}
variable subnet_1_cidr_block {}
variable env_prefix {}
variable avail_zone {}
variable my_ip {}
variable instance_type {}




data "aws_ami" "amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "ami_id" {
  value = data.aws_ami.amazon-linux-image.id
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
      Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_1_cidr_block
  availability_zone = var.avail_zone
  tags = {
      Name = "${var.env_prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
        vpc_id = aws_vpc.myapp-vpc.id

    tags = {
     Name = "${var.env_prefix}-internet-gateway"
   }
}

/*resource "aws_route_table" "myapp-route-table" {
   vpc_id = aws_vpc.myapp-vpc.id

   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.myapp-igw.id
   }

   tags = {
     Name = "${var.env_prefix}-route-table"
   }
 } */

 resource "aws_default_route_table" "main-rtb" {
    default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    tags = {
        Name = "${var.env_prefix}-main-rtb"
    }
}



resource "aws_default_security_group" "default-sg" {
  vpc_id = aws_vpc.myapp-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-default-sg"
  }
}


resource "aws_key_pair" "ssh-key" {
  key_name   = "myapp-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYlDlr8hgHkKBNqu2m0g6qWbIXGmss5vWTc8ZjYMqxJv5sYX+kNkkeyn2wC06KSWKQ8DpAE6dGnhlsWmc2/ZXjPKjCkx6ne4axdRU1vXIeC7Dq5T9gsdilbL0oRF7UJyE8oXs6xR66i8Kdaujwo5wSMihcVIkUVUqXYZCKm+gnPQLMAUcvXO2coCR8GH4tr7SssfGsEGubDjEFFr0tOKYW2qOV7Pj/69X3Vasqys2HtegXAXWjShSb1zN3LPmMOdYLs6AG4V0wJH2geQ/i97FVSk7O5CpmYByAkXVuPbRtoXQgb1PcbhZMQi2WPDlCP3HcRoB3rnds9nYm0eKtUXQHQmiCIi1YPAdqRvpyGdfoq9S4X/YmjTgOAvwcAmK24saDTjYbmOAkjhEOh+tEtxGs/358L1QzQpatt0pCieZqyXgzpVosTWc9QoZhew0RtaZ9eVL2+rwhxavrhZU/oxpUHj50892YzsthPtRjxZOelk/H8gV7/TlFZhHTkB6V1Gk= ubuntu@ip-172-31-43-43"

}

output "server-ip" {
    value = aws_instance.myapp-server.public_ip
}

resource "aws_instance" "myapp-server" {
  ami                         = data.aws_ami.amazon-linux-image.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids      = [aws_default_security_group.default-sg.id]
  availability_zone                           = var.avail_zone


user_data = file("entrypoint.sh")

  tags = {
    Name = "${var.env_prefix}-server"
  }

}
