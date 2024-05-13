# Terraform Part-2

### Variables:
Variables in Terraform allow you to parameterize your configurations. They provide a way to make your Terraform code reusable and flexible by allowing you to define values that can be passed into resources or modules. Here's a brief explanation of each part:

- **Declaration**: Variables are declared using the `variable` block in a Terraform configuration file (e.g., `variables.tf`).
- **Definition**: You can define default values for variables using the `default` argument within the `variable` block.
- **Usage**: Variables can be used throughout your Terraform configuration by referencing them using the `var` syntax (e.g., `var.instance_type`).

### Data Sources:
Data sources in Terraform allow you to fetch information from existing infrastructure components in your cloud provider. They enable you to reference external resources and use their attributes in your configuration. Here's how they work:

- **Declaration**: Data sources are declared using the `data` block in a Terraform configuration file.
- **Configuration**: You specify the type of data source (e.g., `aws_vpc`, `aws_subnet`), and then provide any necessary parameters (e.g., filters).
- **Usage**: You can reference attributes of the data source using dot notation (e.g., `data.aws_subnet.example.id`).

### Terraform State (`terraform.tfstate`):
The Terraform state file (`terraform.tfstate`) is a JSON file that keeps track of the state of your infrastructure. It contains information about the resources managed by Terraform, such as their IDs, attributes, and dependencies. Here's what you need to know about it:

- **Contents**: The state file includes detailed information about each resource managed by Terraform, including metadata and dependencies.
- **Location**: By default, the state file is stored locally in the same directory as your Terraform configuration files, but it can also be stored remotely for collaboration and consistency across teams.
- **Usage**: Terraform uses the state file to plan and apply changes to your infrastructure. It compares the current state with the desired state defined in your configuration files to determine what actions need to be taken.

### Terraform State Backup (`terraform.tfstate.backup`):
The Terraform state backup file (`terraform.tfstate.backup`) is a backup of the previous state file. It's automatically created by Terraform whenever it updates the state file during a `terraform apply` operation. Here's its purpose:

- **Backup**: The backup file ensures that you have a copy of the previous state in case something goes wrong during a `terraform apply` operation.
- **Safety Net**: If Terraform encounters an error or interruption during the `apply`, it can use the backup file to restore the previous state, helping to prevent accidental changes or data loss.
- **Usage**: The backup file is primarily for safety and recovery purposes and is not directly used by Terraform during its normal operation. It's recommended to keep this file alongside your main state file for reference.

In summary, variables allow you to parameterize your configurations, data sources fetch information from existing infrastructure, the Terraform state file maintains the state of your infrastructure, and the state backup file provides a safety net in case of errors or interruptions during operations.

# EC2-Instance Project-2

### Variables:
```hcl
variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-0a7cf821b91bcccbc" # Replace with your desired AMI ID
}

variable "ssh_key_name" {
  default = "Key" # Replace with your SSH key name
}
```
- Variables in Terraform allow you to parameterize your configurations.
- In this section, you've defined three variables: `instance_type`, `ami_id`, and `ssh_key_name`.
- Each variable has a default value, but these defaults can be overridden when running Terraform commands.

### Data Sources:
```hcl
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "example" {
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "Subnet-A"
  }
}
```
- Data sources in Terraform allow you to fetch information from existing infrastructure components in your cloud provider.
- Here, you're using the `aws_vpc` data source to fetch details about the default VPC and the `aws_subnet` data source to fetch details about a subnet within the default VPC.
- In the `aws_subnet` data source, you're filtering subnets based on the `vpc_id` retrieved from the `aws_vpc` data source.

### Resource: Security Group:
```hcl
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Security group for EC2 instance"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```
- Resources in Terraform represent infrastructure components that you want to manage.
- Here, you're defining an `aws_security_group` resource named `instance_sg`.
- This security group allows inbound traffic on ports 22 (SSH) and 80 (HTTP), and it allows all outbound traffic.
- The `vpc_id` attribute is set to the ID of the default VPC obtained from the `aws_vpc` data source.

### Resource: EC2 Instance:
```hcl
resource "aws_instance" "ec2-instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = data.aws_subnet.example.id
  security_groups = [aws_security_group.instance_sg.id]
  key_name      = var.ssh_key_name

  tags = {
    Name = "ExampleEC2Instance"
  }
}
```
- This section defines an `aws_instance` resource named `ec2-instance`.
- It specifies the AMI, instance type, subnet ID, security group, and SSH key name for the EC2 instance.
- The `subnet_id` is obtained from the `aws_subnet` data source.
- The `security_groups` attribute references the security group created earlier (`aws_security_group.instance_sg`).

Overall, this Terraform configuration sets up an EC2 instance with a security group allowing SSH and HTTP traffic, using a default VPC and subnet. It utilizes variables to customize settings and data sources to fetch existing infrastructure details.
