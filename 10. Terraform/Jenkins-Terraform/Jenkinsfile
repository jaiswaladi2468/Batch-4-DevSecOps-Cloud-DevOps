pipeline {
    agent any
    
    tools {
        terraform 'terraform1.57'
    }

    stages {
        stage('Git') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/jaiswaladi2468/J-TERRA.git'
            }
        }
        
        stage('terra') {
            steps {
                sh "terraform -v"
                dir('/root/.jenkins/workspace/Terraform-With-Jenkins/T-Scripts/') {
                    sh "terraform init"    
                    sh "terraform plan"
                    //sh "terraform apply --var-file terraform.tfvars --auto-approve"
                    sh "terraform destroy --auto-approve"
                }
                
            }
        }
    }
}
