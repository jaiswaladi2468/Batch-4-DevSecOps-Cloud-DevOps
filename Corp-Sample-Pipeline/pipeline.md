
```groovy
pipeline {
    agent any

    options {
        buildDiscarder(logRotator(artifactDaysToKeepStr: '1', artifactNumToKeepStr: '1', daysToKeepStr: '5', numToKeepStr: '50'))
        disableConcurrentBuilds()
    }

    tools {
        nodejs "NodeJS-version"
        oc "OpenShift_tool_name"
    }

   environment {
    buildScript = 'build'
    lintScript = 'lint'
    testScript = 'test:ci'
    srcDir = 'src'
    chrome = 'Chrome-stable'
    python = 'python3.9'

    sonarTool = 'Sonar-scanner'
    sonarEnv = "sonar"

    groupId = 'com.devopsshack'
    repositoryId = 'nexus'
    repositoryUrl = 'http://ip:8081/repository/'
    globalSettingsId = 'global-settings'
    mavenInstallation = 'Maven3'

    dockerFileName = 'Dockerfile'
    dockerRegistryProtocol = 'https://'
    dockerRegistry = 'private-docker-registry'
    dockerRegistryCredentials = 'docker-cred'
    dockerTool = 'docker-tool-name'

    openShiftUrl = 'XYZ.com'
    openShiftCredentials = 'Dev-op-cred'
    openShiftNamespace = 'webapps'

    
}
        
    stages {
        stage('Fresh Deppendency Installation') {
                when {
                anyOf {
                    branch 'master'
                    branch 'develop'
                    branch 'release/*'
                    branch 'feature/*'
                    branch 'hotfix/*'
                    branch 'bugfix/*'
                    
                }
            }
            steps {
                sh "yarn install --ignore-engines"
            }
        }

        stage('Code Linting') {
            steps {
                when {
                anyOf {
                    branch 'master'
                    branch 'develop'
                    branch 'release/*'
                    branch 'feature/*'
                    branch 'hotfix/*'
                    branch 'bugfix/*'
                   
                }
            }
            steps {
                sh """yarn ${lintScript}"""
            }
        }
           

        stage('Angular tests') {
            when {
                anyOf {
                    branch 'develop'
                    branch 'release/*'
                    branch 'feature/*'
                    branch 'bugfix/*'
                    
                }
            }
            steps {
                sh """yarn ${testScript}"""
            }
        }


        stage('OWASP Dependency Check') {
            when {
                anyOf {
                    branch 'master'
                    branch 'develop'
                    branch 'release/*'
                }
            }
            steps{
                dependencyCheck additionalArguments: '',odcInstallation: 'DependencyCheck-9.0.2'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml' 
            }
        }


       stage ('SonarQube code analysis') {
            when {
                anyOf {
                    branch 'master'
                    branch 'develop'
                    branch 'release/*'
                }
            }
            steps {
                script {
                    stagename = "${env.STAGE_NAME}"
                    def scannerHome = tool sonarTool
                    def props = readJSON file: 'package.json'
                    sonarCheck = "- Check [SonarQube Analysis](https://IP-ADDRESS:9000/sonarqube/dashboard?id=${props.name}${sonarProjectKey}) for ${props.name}${sonarProjectKey}."
                    withSonarQubeEnv(sonarEnv) {
                        sh """
                            ${scannerHome}/bin/sonar-scanner \
                                -Dsonar.projectKey=${props.name}${sonarProjectKey} \
                                -Dsonar.projectName=${props.name}${sonarProjectKey} \
                                -Dsonar.projectVersion=${props.version} \
                                -Dsonar.sources=${srcDir} \
                                -Dsonar.typescript.lcov.reportPaths=coverage/lcov.info \
                                -Dsonar.exclusions='**/*.spec.ts, **/*.model.ts, **/*mock.ts, src/environments/*, **/*.d.ts, **/*.module.ts, **/main.ts, **/*contracts-definition.ts, **/dialogs-constants-data.ts, **/magic-words.ts, **/index.ts, **/*.conf.ts, src/app/shared/test/*, **/*.constants.ts, **/karma.conf.js'
                        """
                    }
                    timeout(time: 1, unit: 'HOURS') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }

        stage ('Build Application') {
            when {
                anyOf {
                    branch 'master'
                    branch 'develop'
                    branch 'release/*'
                    branch 'feature/*'
                    branch 'hotfix/*'
                    branch 'bugfix/*'
                    changeRequest()
                }
            }
            steps {
                sh """yarn ${buildScript}"""
            }
        }

        stage ('Deliver application into Nexus') {
            when {
                anyOf {
                    branch 'master'
                    branch 'release-candidate'
                    branch 'develop'
                    branch 'release/*'
                }
            }
            steps {
                script {
                    
                    def props = readJSON file: 'package.json'
                    zip dir: 'dist/', zipFile: """${props.name}.zip"""
                    version = props.version
                    if (!version.endsWith("-SNAPSHOT") && env.BRANCH_NAME == 'develop') {
                        version = "${version}-SNAPSHOT"
                        version = version.replace("-RC", "")
                    }

                    if (!version.endsWith("-RC")) {
                        if(env.BRANCH_NAME == "release-candidate") {
                            version = "${version}-RC"
                            version = version.replace("-SNAPSHOT", "")
                        } else if( env.BRANCH_NAME.startsWith('release/')) {
                            version = "${version}-UAT"
                            version = version.replace("-SNAPSHOT", "")
                        }
                    }

                    if (env.BRANCH_NAME == 'master' && (version.endsWith("-RC") || version.endsWith("-SNAPSHOT"))){
                        version = version.replace("-RC", "")
                        version = version.replace("-SNAPSHOT", "")
                    }

                    withMaven(globalMavenSettingsConfig: globalSettingsId, maven: mavenInstallation) {
                        sh """
                            mvn deploy:deploy-file \
                                -DgroupId=${groupId} \
                                -DartifactId=${props.name} \
                                -Dversion=${version} \
                                -Dpackaging=zip \
                                -Dfile=${props.name}.zip \
                                -DrepositoryId=${repositoryId} \
                                -Durl=${repositoryUrl}${repositoryName}
                        """
                    }
                }
            }
        }


        stage ('Create the Docker image') {
            when {
                anyOf {
                    branch 'master'
                    branch 'develop'
                    branch 'release/*'
                }
            }
            steps {
                script {
                    docker.withRegistry("""${dockerRegistryProtocol}${dockerRegistry}""", dockerRegistryCredentials) {
                        def props = readJSON file: 'package.json'
                        dir('dist') {
                            def customImage = docker.build("${props.name}:${props.version}", "-f ${dockerFileName} .")
                            customImage.push()
                            customImage.push(dockerTag);
                        }
                    }
                }
            }
        }

        stage ('Deploy the new image') {
            when {
                anyOf {
                    branch 'develop'
                    branch 'release/*'
                }
            }
            steps{
                script {
                    props = readJSON file: 'package.json'
                    withCredentials([usernamePassword(credentialsId: "${openShiftCredentials}", passwordVariable: 'pass', usernameVariable: 'user')]) {
                        sh "oc login -u ${user} -p ${pass} ${openshiftUrl} --insecure-skip-tls-verify"
                        sh "oc project ${openShiftNamespace}"
                        try {
                            sh "oc import-image ${props.name} --namespace=${openShiftNamespace} --from=${dockerRegistry}/${props.name} --confirm"
                        } catch (e) {
                            sh """
                                oc logs \$(oc get builds -l build=${props.name} --namespace=${openShiftNamespace} --sort-by=.metadata.creationTimestamp -o name | tail -n 1) --namespace=${openShiftNamespace}
                                throw e
                            """
                        }
                    }
                }
            }
        }

        stage ('Check pod status') {
            when {
                anyOf {
                    branch 'develop'
                    branch 'release/*'
                }
            }
            steps{
                script {
                    stagename = "${env.STAGE_NAME}"
                    props = readJSON file: 'package.json'
                    sleep 60
                    withCredentials([usernamePassword(credentialsId: "${openShiftCredentials}", passwordVariable: 'pass', usernameVariable: 'user')]) {
                        sh "oc login -u ${user} -p ${pass} ${openshiftUrl} --insecure-skip-tls-verify"
                        sh "oc project ${openShiftNamespace}"
                        sh "oc get pos"
                        sh "oc get svc"

    post {
    success {
        // Send email notification with green banner for success
        emailext (
            subject: "Build Successful: ${currentBuild.fullDisplayName}",
            body: """<h2 style='color:green;'>Build Successful</h2><p>Details: ${BUILD_URL}</p>""",
            recipientProviders: [[$class: 'DevelopersRecipientProvider']],
            attachLog: true
        )
    }
    failure {
        // Send email notification with red banner for failure
        emailext (
            subject: "Build Failed: ${currentBuild.fullDisplayName}",
            body: """<h2 style='color:red;'>Build Failed</h2><p>Details: ${BUILD_URL}</p>""",
            recipientProviders: [[$class: 'DevelopersRecipientProvider']],
            attachLog: true
        )
    }
    always {
        // Clean up workspace
        cleanWs()
    }
}
```

## Explanation

1. `pipeline {`: This defines the start of a Jenkins pipeline block.

2. `agent any`: This specifies that the pipeline can run on any available agent (slave node).

3. `options {`: This starts the options block where you can define various pipeline options.

4. `buildDiscarder(logRotator(artifactDaysToKeepStr: '1', artifactNumToKeepStr: '1', daysToKeepStr: '5', numToKeepStr: '50'))`: This specifies the build discarder strategy using LogRotator, which rotates the logs based on the specified criteria.

5. `disableConcurrentBuilds()`: This option disables concurrent builds to ensure that only one instance of the pipeline can run at a time.

6. `tools {`: This section allows you to define tools used in the pipeline, such as Node.js and OpenShift.

7. `nodejs "NodeJS-version"`: This specifies the Node.js tool to use in the pipeline with a specific version.

8. `oc "OpenShift_tool_name"`: This specifies the OpenShift tool to use in the pipeline with a specific name.

9. `environment {`: This section allows you to define environment variables used throughout the pipeline.

10. `buildScript = 'build'`: Defines a variable `buildScript` with the value `'build'`.

11. `lintScript = 'lint'`: Defines a variable `lintScript` with the value `'lint'`.

12. `testScript = 'test:ci'`: Defines a variable `testScript` with the value `'test:ci'`.

13. `srcDir = 'src'`: Defines a variable `srcDir` with the value `'src'`.

14. `chrome = 'Chrome-stable'`: Defines a variable `chrome` with the value `'Chrome-stable'`.

15. `python = 'python3.9'`: Defines a variable `python` with the value `'python3.9'`.

16. `sonarTool = 'Sonar-scanner'`: Defines a variable `sonarTool` with the value `'Sonar-scanner'`.

17. `sonarEnv = "sonar"`: Defines a variable `sonarEnv` with the value `'sonar'`.

18. `groupId = 'com.devopsshack'`: Defines a variable `groupId` with the value `'com.devopsshack'`.

19. `repositoryId = 'nexus'`: Defines a variable `repositoryId` with the value `'nexus'`.

20. `repositoryUrl = 'http://ip:8081/repository/'`: Defines a variable `repositoryUrl` with the value `'http://ip:8081/repository/'`.

21. `globalSettingsId = 'global-settings'`: Defines a variable `globalSettingsId` with the value `'global-settings'`.

22. `mavenInstallation = 'Maven3'`: Defines a variable `mavenInstallation` with the value `'Maven3'`.

23. `dockerFileName = 'Dockerfile'`: Defines a variable `dockerFileName` with the value `'Dockerfile'`.

24. `dockerRegistryProtocol = 'https://'`: Defines a variable `dockerRegistryProtocol` with the value `'https://'`.

25. `dockerRegistry = 'private-docker-registry'`: Defines a variable `dockerRegistry` with the value `'private-docker-registry'`.

26. `dockerRegistryCredentials = 'docker-cred'`: Defines a variable `dockerRegistryCredentials` with the value `'docker-cred'`.

27. `dockerTool = 'docker-tool-name'`: Defines a variable `dockerTool` with the value `'docker-tool-name'`.

28. `openShiftUrl = 'XYZ.com'`: Defines a variable `openShiftUrl` with the value `'XYZ.com'`.

29. `openShiftCredentials = 'Dev-op-cred'`: Defines a variable `openShiftCredentials` with the value `'Dev-op-cred'`.

30. `openShiftNamespace = 'webapps'`: Defines a variable `openShiftNamespace` with the value `'webapps'`.

