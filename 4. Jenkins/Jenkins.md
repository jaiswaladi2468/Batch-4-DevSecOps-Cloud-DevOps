## Jenkins Installation and Configuration Guide

### Prerequisites
Before installing Jenkins, ensure that Java is installed on your system. You can install OpenJDK 17 using the following command:

```bash
sudo apt install openjdk-17-jre-headless -y
```

### Installing Jenkins
1. Create a script file named `install-jenkins.sh`:

```bash
vi install-jenkins.sh
```

2. Copy the following content into the script:

```bash
#!/bin/bash

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
```

3. Change the permission to execute:

```bash
sudo chmod +x install-jenkins.sh
```

4. Execute the script to install Jenkins:

```bash
./install-jenkins.sh
```

### Accessing Jenkins
1. Access Jenkins through your browser using your server's public IP address and port `8080`.
   Example: `http://your_public_ip:8080`

2. Retrieve the initial admin password to log in to Jenkins:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### Installing Plugins & Configuring JDK
1. Go to `Manage Jenkins` -> `Manage Plugins` -> `Available` tab.
2. Search for "Eclipse Temurin Installer" and install it.
3. Navigate to `Manage Jenkins` -> `Global Tool Configuration` -> `JDK installations`.
4. Add JDK:
   - Provide a name for the JDK.
   - Select "Install automatically" option.
   - Choose "Install from adoptium.net" option.
   - Configure JDK 17.

### Sample Pipeline
Below is a sample Jenkins pipeline script:

```groovy
pipeline {
    agent any

    tools {
        jdk 'jdk_name'
        maven 'maven_name'
    }

    stages {
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn package'
            }
        }
    }
}
```

Replace `'jdk_name'` and `'maven_name'` with the appropriate names of the JDK and Maven installations configured in your Jenkins instance.

This pipeline script compiles, tests, and builds a Maven project. You can modify it according to your project requirements.

## To set up trigger for a Pipeline Using a Generic WebHook Trigger
To configure a Jenkins job to trigger from a generic webhook, follow these steps:

### Install Generic Webhook Trigger Plugin
1. Go to Jenkins dashboard.
2. Navigate to `Manage Jenkins` -> `Manage Plugins`.
3. In the `Available` tab, search for "Generic Webhook Trigger".
4. Install the plugin and restart Jenkins if necessary.

### Configure Jenkins Job
1. Create or open the Jenkins job you want to trigger.
2. In the job configuration, scroll down to the `Build Triggers` section.
3. Check the checkbox for `Generic Webhook Trigger`.

### Configure Post Parameters
1. In the `Post Parameters` section, add the following:
   - **Variable**: `ref`
   - **Expression (JSON)**: `$.ref`

### Generate Github Token
1. Generate a Github token that will be used in the webhook URL.

### Configure Optional Filter
1. In the `Optional Filter` section, configure the following:
   - **Expression**: `refs/heads/branch_name` (Replace `branch_name` with the name of your branch)
   - **Text**: `$ref`

### Configure Github Webhook
1. Go to your Github repository settings.
2. Navigate to `Webhooks`.
3. Click `Add webhook`.
4. In the `Payload URL` field, enter the following URL:
   ```
   Jenkins_URL/generic-webhook-trigger/invoke?token=github_token
   ```
   Replace `Jenkins_URL` with the URL of your Jenkins instance and `github_token` with the token generated earlier.
   Example: `http://65.0.31.109:8080/generic-webhook-trigger/invoke?token=github_token`
5. Set the `Content type` to `application/json`.
6. Select the events you want to trigger the webhook for (e.g., `Pushes`).

### Save Changes
1. Save your Jenkins job configuration.

Now, your Jenkins job is configured to trigger via a generic webhook whenever a push event occurs on the specified branch in your Github repository.

## To set up trigger for a multibranch pipeline in Jenkins using the Multibranch Scan Webhook Trigger Plugin, follow these steps:

### Install Multibranch Scan Webhook Trigger Plugin
1. Navigate to Jenkins dashboard.
2. Go to `Manage Jenkins` -> `Manage Plugins`.
3. In the `Available` tab, search for "Multibranch Scan Webhook Trigger".
4. Install the plugin and restart Jenkins if required.

### Configure Multibranch Pipeline Job
1. Create or open the multibranch pipeline job you want to trigger.
2. In the job configuration, navigate to `Scan Multibranch Pipeline Triggers`.
3. Select `Scan by webhook`.
4. Enter any trigger token in the `Trigger token` field.

### Configure Github Webhook
1. Go to your Github repository settings.
2. Navigate to `Webhooks`.
3. Click `Add webhook`.
4. In the `Payload URL` field, enter the following URL:
   ```
   Jenkins_URL/multibranch-webhook-trigger/invoke?token=token_value
   ```
   Replace `Jenkins_URL` with the URL of your Jenkins instance and `token_value` with the trigger token you configured in the Jenkins job.
   Example: `http://65.0.31.109:8080/multibranch-webhook-trigger/invoke?token=Devopsshack`
5. Set the `Content type` to `application/json`.
6. Select the events you want to trigger the webhook for (e.g., `Pushes`).

### Save Changes
1. Save your Jenkins job configuration.

Now, your multibranch pipeline job is configured to trigger via webhook whenever a push event occurs on your Github repository.
