To securely manage secret keys and access keys in a Terraform integrated Jenkins pipeline, you can use Jenkins credentials, which provide a way to securely store and retrieve sensitive information. Here's a step-by-step guide on how to do this:

1. **Create Jenkins Credentials**:

   - Open your Jenkins dashboard and navigate to "Manage Jenkins" > "Manage Credentials".
   - Click on "(global)" domain or any domain where you want to store your credentials.
   - Click on "Add Credentials" on the left sidebar.
   - Fill in the required information:
     - **Kind**: Select the appropriate type for your secret (e.g., "Secret text" for AWS secret key).
     - **Scope**: Choose "Global" if you want the credentials to be available across all jobs, or choose a specific scope as per your requirement.
     - **Secret**: Enter your secret key.
     - **ID**: Give it a unique identifier (e.g., `aws_secret_key`).
     - **Description**: Optionally, add a description.
   - Click "OK" to save the credentials.

2. **Integrate Credentials in Your Jenkins Pipeline**:

   In your Jenkins pipeline script (usually in a Jenkinsfile stored in your version control system), you can now use the credentials you created.

   For example, if you're using the AWS CLI in your Terraform script, you can use the AWS secret key like this:

   ```groovy
   pipeline {
       agent any
       environment {
           AWS_SECRET_KEY = credentials('aws_secret_key')
       }
       stages {
           stage('Terraform Apply') {
               steps {
                   script {
                       sh "aws configure set aws_secret_access_key ${AWS_SECRET_KEY}"
                       sh "terraform apply -auto-approve"
                   }
               }
           }
       }
   }
   ```

   In this example, we're setting the `AWS_SECRET_KEY` environment variable with the value from the credentials.

3. **Configure Terraform with the Credentials**:

   In your Terraform configuration files, you can now use environment variables to access the secret key:

   ```hcl
   provider "aws" {
     region     = "us-west-2"
     access_key = var.aws_access_key
     secret_key = var.aws_secret_key
   }
   ```

   Ensure that you have `var.aws_access_key` and `var.aws_secret_key` defined in your Terraform variables.

4. **Secure the Jenkins Environment**:

   - Make sure your Jenkins server is properly secured. Limit access only to authorized personnel.
   - Use Jenkins best practices for security, like using role-based access control (RBAC), configuring firewall rules, and regularly updating Jenkins and its plugins.

5. **Regularly Rotate Credentials**:

   Periodically rotate your secret keys and update the credentials in Jenkins accordingly.

By following these steps, you can securely manage secret keys and access keys in a Jenkins pipeline integrated with Terraform. This helps to keep your sensitive information safe while automating your infrastructure deployment.
