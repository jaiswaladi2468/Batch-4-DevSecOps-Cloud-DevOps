-

**Setting Up SonarQube with Jenkins Pipeline**

**1. Create a Ubuntu Virtual Machine (VM)**

- Set up a Ubuntu VM.
- Install Docker.

```bash
sudo apt install docker.io -y
sudo chmod 666 /var/run/docker.sock
```

**2. Set Up SonarQube LTS-Community Version**

- For the standard SonarQube LTS-Community Version:

```bash
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
```

- For the Community Branch Plugin version of SonarQube:

```bash
docker run -d --name sonar -p 9000:9000 mc1arke/sonarqube-with-community-branch-plugin
```

**3. Install SonarQube Scanner Plugin & Configure in Jenkins Tools**

- Ensure SonarQube Scanner Plugin is installed and configured in Jenkins tools.

**4. Configure SonarQube Server in Jenkins System**

- Set up SonarQube server configuration in Jenkins.

**5. Configure Webhook in SonarQube**

- Before adding a quality gate in the pipeline, ensure a webhook is added in SonarQube:
  - Go to Administration > Configuration > Webhook.
  - Add the following format: `JENKINS_URL/sonarqube-webhook/`

**6. Jenkins Pipeline**

```groovy
pipeline {
    agent any
    
    tools {
        maven 'maven3'
        jdk 'jdk17'
        sonar 'sonar-scanner' // Ensure SonarQube scanner tool is configured
    }
    
    environment {
        SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git 'https://github.com/jaiswaladi2468/BoardgameListingWebApp.git'
            }
        }
        
        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }
        
        stage('Test') {
            steps {
                sh "mvn test"
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-1') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Boardgame -Dsonar.projectKey=Boardgame \
                    -Dsonar.branch.name=pre-master -Dsonar.java.binaries=target/classes '''
                }
            }
        }
        
        stage('Quality Gate Check') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'new-sonar-token'
                }
            }
        }
        
        stage('Build') {
            steps {
                sh "mvn package"
            }
        }
    }
}
```

