pipeline {
    agent any

    environment {
        IMAGE_NAME = 'yourdockerhubusername/yourapp'
        DOCKER_CREDENTIALS = 'dockerhub-creds'
        GIT_CREDENTIALS = 'github-creds'
    }

    options {
        skipDefaultCheckout()
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    // Checkout code
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: '*/main']],
                        doGenerateSubmoduleConfigurations: false,
                        userRemoteConfigs: [[
                            url: 'https://github.com/Ayushmaan7/delta_project.git',
                            credentialsId: env.GIT_CREDENTIALS
                        ]]
                    ])

                    // Determine commits for diff
                    def previousCommit = env.GIT_PREVIOUS_COMMIT ?: sh(script: 'git rev-parse HEAD~1', returnStdout: true).trim()
                    def currentCommit = env.GIT_COMMIT ?: sh(script: 'git rev-parse HEAD', returnStdout: true).trim()

                    // Get list of changed files
                    def changes = sh(
                        script: "git diff --name-only ${previousCommit} ${currentCommit}",
                        returnStdout: true
                    ).trim().split("\n")

                    // Define blocking files/directories
                    def blockingFiles = ['Jenkinsfile', 'Dockerfile']
                    def blockingDirs = ['infra/']

                    // Check for blocking changes
                    boolean onlyBlockingChanges = true
                    for (file in changes) {
                        if (!blockingFiles.contains(file) && !blockingDirs.any { file.startsWith(it) }) {
                            onlyBlockingChanges = false
                            break
                        }
                    }

                    if (onlyBlockingChanges) {
                        // Mark build as SUCCESS but skip remaining stages
                        currentBuild.result = 'SUCCESS'
                        echo "Pipeline skipped: Only Jenkinsfile, Dockerfile, or infra/ changes detected."
                        // Exit early from pipeline stages
                        return
                    }
                }
            }
        }

        stage('Build Docker Image') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                script {
                    def buildNumberTag = "${env.BUILD_NUMBER}"
                    docker.build("${env.IMAGE_NAME}:${buildNumberTag}")
                    docker.build("${env.IMAGE_NAME}:latest")
                }
            }
        }

        stage('Push Docker Image') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKER_CREDENTIALS) {
                        def buildNumberTag = "${env.BUILD_NUMBER}"
                        docker.image("${env.IMAGE_NAME}:${buildNumberTag}").push()
                        docker.image("${env.IMAGE_NAME}:latest").push()
                    }

                    // Remove Docker images from Jenkins node to save disk space
                    sh """
                        docker rmi -f ${env.IMAGE_NAME}:${env.BUILD_NUMBER} || true
                        docker rmi -f ${env.IMAGE_NAME}:latest || true
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully."
        }
        failure {
            echo "Pipeline failed due to an error!"
        }
    }
}
}

