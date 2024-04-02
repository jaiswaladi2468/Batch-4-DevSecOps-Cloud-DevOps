## Setting up Jenkins Email Notifications with Gmail SMTP Server

### Overview
In Jenkins pipelines, you can configure email notifications to be sent upon completion of builds using a SMTP server. This guide outlines the steps to configure Jenkins to send email notifications using Gmail's SMTP server (smtp.gmail.com) over SSL on port 465.

### Prerequisites
- Jenkins instance installed and accessible
- Pipeline job configured in Jenkins
- Gmail account for sending emails

### Steps

#### 1. Generate Gmail App Password
- Go to your Google Account settings and navigate to Security.
- Under "Signing in to Google," click on "App passwords."
- Generate an app password for Jenkins by selecting "Mail" and your device.
- Save this password securely as it will be used as the `app_password` in Jenkins.

#### 2. Configure Jenkins Email Notification
- Log in to your Jenkins instance.
- Navigate to "Manage Jenkins" > "Configure System."
- Scroll down to the "Extended E-mail Notification" section.
- Check the "Enable SSL" box.
- Add port `465` for SSL.
- Set the SMTP server to `smtp.gmail.com`.
- Enter your Gmail email address in the "User Name" field.
- Enter the generated app password in the "Password" field.
- Save the configuration.

#### 3. Configure Pipeline
- Open your Jenkins pipeline script.
- Add the following code snippet at the pipeline level:

```groovy
post {
    always {
        script {
            def jobName = env.JOB_NAME
            def buildNumber = env.BUILD_NUMBER
            def pipelineStatus = currentBuild.result ?: 'UNKNOWN'
            def bannerColor = pipelineStatus.toUpperCase() == 'SUCCESS' ? 'green' : 'red'

            def body = """
                <html>
                <body>
                <div style="border: 4px solid ${bannerColor}; padding: 10px;">
                <h2>${jobName} - Build ${buildNumber}</h2>
                <div style="background-color: ${bannerColor}; padding: 10px;">
                <h3 style="color: white;">Pipeline Status: ${pipelineStatus.toUpperCase()}</h3>
                </div>
                <p>Check the <a href="${BUILD_URL}">console output</a>.</p>
                </div>
                </body>
                </html>
            """

            emailext (
                subject: "${jobName} - Build ${buildNumber} - ${pipelineStatus.toUpperCase()}",
                body: body,
                to: 'recipient@example.com', // Replace with recipient email address
                from: 'jenkins@example.com', // Replace with sender email address
                replyTo: 'jenkins@example.com', // Replace with reply-to email address
                mimeType: 'text/html'
            )
        }
    }
}
```

- Replace `'recipient@example.com'` with the email address to which you want to send notifications.
- Update `'jenkins@example.com'` with your Jenkins instance's email address.
- Ensure `replyTo` is set to the same email address as `from`.
- Save the pipeline script.


# Sample Pipeline


### Conclusion
With these configurations, Jenkins will send email notifications upon completion of pipeline builds. Notifications will include details such as build status, build number, and a link to the console output. This setup ensures effective communication and tracking of build statuses.
