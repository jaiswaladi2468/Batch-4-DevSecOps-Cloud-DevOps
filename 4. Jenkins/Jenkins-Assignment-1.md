
### 1. Setup Jenkins on a t2.medium machine
   - Install Jenkins on a t2.medium EC2 instance following the appropriate installation instructions for your operating system.

### 2. Install Eclipse Temurin Installer Plugin
   - In Jenkins, navigate to `Manage Jenkins` -> `Manage Plugins`.
   - In the `Available` tab, search for "Eclipse Temurin Installer" and install it.

### 3. Configure JDK & Maven in Tools Section
   - Go to `Manage Jenkins` -> `Global Tool Configuration`.
   - Configure JDK and Maven installations under the respective sections. Use Eclipse Temurin Installer for JDK installation.

### 4. Create a Freestyle Job
   - Create a new freestyle job in Jenkins.
   - Configure the job to use Maven as the build step and specify Maven goals.
   - Set up any additional build steps or post-build actions as required.

### 5. Create a Pipeline Job
   - Create a new pipeline job in Jenkins.
   - Define stages for testing and building the application within the pipeline script.

### 6. Create a Trigger for Pipeline Job
   - Install the Generic Webhook Trigger plugin if not already installed.
   - Configure a generic webhook trigger for the pipeline job to trigger on push events for branches other than master.

### 7. Create a Multibranch Pipeline
   - Create a new multibranch pipeline job in Jenkins.
   - Configure it to scan a repository for branches.

### 8. Create a Multibranch Pipeline Webhook
   - In the multibranch pipeline job configuration, enable "Scan Multibranch Pipeline Triggers".
   - Configure a webhook to trigger the scan for new branches.

### 9. Create a t2.medium VM as a Jenkins Slave
   - Launch a t2.medium EC2 instance in AWS.
   - Install Java and any other necessary dependencies on the VM.
   - Add the VM as a Jenkins slave node in Jenkins master configuration.
   - Configure the pipeline job to execute on the t2.medium slave node.

