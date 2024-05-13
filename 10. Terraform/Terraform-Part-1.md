# Terraform | Part-1

Terraform is an open-source infrastructure as code (IaC) tool developed by HashiCorp. It allows users to define and provision infrastructure using a high-level configuration language called HashiCorp Configuration Language (HCL) or optionally JSON. Terraform manages infrastructure resources such as virtual machines, networks, storage, and many others from various cloud providers and on-premises environments.

Here's a detailed explanation of Terraform's key concepts and how to use them with examples:

1. **Providers**:
   Providers are plugins that Terraform uses to interact with different infrastructure platforms, such as AWS, Azure, Google Cloud Platform, and more. Each provider has its own set of resources and data sources that can be managed with Terraform. To use a provider, you need to declare it in your configuration.

   Example:
   ```hcl
   provider "aws" {
     region = "us-west-2"
   }
   ```

2. **Resources**:
   Resources represent the infrastructure components you want to manage, such as virtual machines, databases, or networks. Each resource type is defined by the provider and has specific attributes that you can configure.

   Example:
   ```hcl
   resource "aws_instance" "example_instance" {
     ami           = "ami-0c55b159cbfafe1f0"
     instance_type = "t2.micro"
   }
   ```

3. **Data Sources**:
   Data sources allow Terraform to fetch information about existing infrastructure objects that were not created by Terraform. This could be useful for referencing existing resources or retrieving information like IP addresses or AMI IDs.

   Example:
   ```hcl
   data "aws_ami" "example_ami" {
     most_recent = true
     owners      = ["self"]
     filter {
       name   = "name"
       values = ["my-ami-*"]
     }
   }
   ```

4. **Variables**:
   Variables allow you to parameterize your configurations, making them more flexible and reusable. Variables can be defined at the root module level or within modules.

   Example:
   ```hcl
   variable "instance_type" {
     description = "The type of EC2 instance to launch"
     default     = "t2.micro"
   }
   ```

5. **Modules**:
   Modules are reusable units of Terraform configurations that can be used to encapsulate and organize resources. Modules can be created locally or sourced from remote repositories.

   Example:
   ```hcl
   module "example_module" {
     source = "./example-module"
     instance_count = 2
   }
   ```

6. **Outputs**:
   Outputs allow you to extract and display information from your Terraform configuration after it has been applied. This can be useful for retrieving values like IP addresses or resource IDs.

   Example:
   ```hcl
   output "instance_ip" {
     value = aws_instance.example_instance.private_ip
   }
   ```

7. **State Management**:
   Terraform keeps track of the state of your infrastructure in a state file. This state file is used to map the resources defined in your configuration to real-world infrastructure objects. It's crucial for Terraform to maintain this state to understand the changes it needs to make to your infrastructure.

   Example:
   ```bash
   terraform state list
   ```

8. **Execution Plans**:
   Before applying changes to your infrastructure, Terraform generates an execution plan that outlines what actions it will take. This helps you understand the impact of your changes before they're applied.

   Example:
   ```bash
   terraform plan
   ```

9. **Applying Changes**:
   Once you've reviewed the execution plan and are satisfied with the proposed changes, you can apply them using the `terraform apply` command. Terraform will then make the necessary changes to your infrastructure to match your configuration.

   Example:
   ```bash
   terraform apply
   ```

## Install Terraform & AWS CLI

```bash
https://developer.hashicorp.com/terraform/install

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install
aws configure

```

## SCRIPT-1 Main.TF

Sure, I'll explain each part of your Terraform configuration:

1. **Provider Block**:
   ```hcl
   provider "aws" {
     region = "us-west-2"  # Specify your desired AWS region
   }
   ```
   - This block specifies that you're using the AWS provider to manage AWS resources.
   - The `region` attribute sets the AWS region where your resources will be provisioned.

2. **Resource Block (aws_instance)**:
   ```hcl
   resource "aws_instance" "example_instance" {
     ami                    = "select_AMI"  
     instance_type          = "t2.micro"      
     key_name               = "your-key-pair-name"  #
     vpc_security_group_ids = ["sg-12345678", "sg-87654321"] 
     
     tags = {
       Name = "ExampleInstance"
     }
   }
   ```
   - This block defines an AWS EC2 instance resource named `"example_instance"`.
   - Attributes like `ami`, `instance_type`, `key_name`, and `vpc_security_group_ids` are configured for the instance.
   - The `tags` block allows you to assign metadata to the instance, such as its name.

3. **Output Block**:
   ```hcl
   output "public_ip" {
     value = aws_instance.example_instance.public_ip
   }
   ```
   - This block defines an output named `"public_ip"` that will display the public IP address of the EC2 instance after it's provisioned.
   - The `value` attribute specifies the value to be outputted, in this case, the public IP address of the `example_instance`.

This Terraform configuration describes an AWS EC2 instance to be provisioned in the `us-west-2` region. The instance will be of type `t2.micro`, using a specific AMI (replace `"select_AMI"` with the desired AMI ID), associated with a specified key pair (`"your-key-pair-name"`) and security groups. It will also be tagged with the name `"ExampleInstance"`. After provisioning, the public IP address of the instance will be displayed as output.
