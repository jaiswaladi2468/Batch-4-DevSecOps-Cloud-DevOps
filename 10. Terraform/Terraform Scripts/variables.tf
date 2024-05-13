variable "instance_name" {
        description = "Name of the instance to be created"
        default = "Test-instance"
}

variable "instance_type" {
        default = "t2.micro"
}

variable "subnet_id" {
        description = "The VPC subnet the instance(s) will be created in"
        default = "subnet-0164395797ba54f93"
}

variable "ami_id" {
        description = "The AMI to use"
        default = "ami-08e5424edfe926b43"
}

variable "number_of_instances" {
        description = "number of instances to be created"
        default = 1
}


variable "ami_key_pair_name" {
        default = "Key"
}

variable "resource_tags" {
		description = "Name of the VM on cloud"

}