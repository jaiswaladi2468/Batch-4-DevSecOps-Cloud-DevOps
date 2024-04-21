# Docker issue
```bash
sudo chmod 666 /var/run/docker.sock

sudo systemctl restart docker
```
# Trivy install steps

```bash
sudo apt-get install wget apt-transport-https gnupg lsb-release

wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list

sudo apt-get update

sudo apt-get install trivy -y
```

# Pipeline

```groovy

pipeline {
    agent any
    
    tools{
        jdk 'jdk17'
        maven 'maven3'
    }
    
    environment {
        SONARQUBE_HOME= tool 'sonar-scanner'
    }

    stages {
        stage('Git CheckOut') {
            steps {
                git 'https://github.com/jaiswaladi2468/BoardgameListingWebApp.git'
            }
        }
        
        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }
        
        stage('Unit Tests') {
            steps {
                sh "mvn test"
            }
        }
        
        
        stage('Package') {
            steps {
                sh "mvn package"
            }
        }
        
        stage('OWASP Dependency Check ') {
            steps {
               dependencyCheck additionalArguments: ' --scan ./', odcInstallation: 'DC'
               dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh ''' $SONARQUBE_HOME/bin/sonar-scanner -Dsonar.projectName=Boardgame -Dsonar.projectKey=Boardgame \
                           -Dsonar.java.binaries=. '''
    
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                waitForQualityGate abortPipeline: false
            }
        }
        
        stage('Deploy Artifacts To Nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'global-maven-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: false) {
                      nexusArtifactUploader artifacts: [[artifactId: 'database_service_project', classifier: '', file: '/var/lib/jenkins/workspace/Full-stack-CICD/target/database_service_project-0.0.1.jar', type: 'jar']], credentialsId: 'nx', groupId: 'com.javaproject', nexusUrl: '43.204.25.115:8081/', nexusVersion: 'nexus3', protocol: 'http', repository: 'maven-releases', version: '0.0.1'
}
            }
        }
        
        stage('Deploy Artifacts ') {
            steps {
                withMaven(globalMavenSettingsConfig: 'global-maven-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: false) {
                     sh "mvn deploy"  
                }
            }
        }
        
        stage('Docker Build Image') {
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                    
                    sh "docker build -t boardwebapp:latest ."
                    sh "docker tag boardwebapp:latest adijaiswal/boardwebapp:latest"
    
                }
                    
                }
            }
        }
        
         stage('trivy Image scan') {
            steps {
                sh " trivy image adijaiswal/boardwebapp:latest "
            }
        }
        
        
        stage('Docker Push Image') {
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                  
                    sh "docker push adijaiswal/boardwebapp:latest"
    
                }
                    
                }
            }
        }
        
        
        stage('Deploy application to container') {
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                    
                    sh "docker run -d -p 8085:8080 adijaiswal/boardwebapp:latest"
                    
    
                }
                    
                }
            }
        }
        
    }
}
```
