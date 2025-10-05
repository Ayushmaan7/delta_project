pipeline {
    agent any

    environment {
        IMAGE_NAME = 'yourdockerhubusername/yourapp'
        DOCKER_CREDENTIALS = 'dockerhub-creds'
        GIT_CREDENTIALS = 'github-creds'
    }

    options {
        skipDefaultCheckout() // We'll do manual checkout
    }

    triggers {
        pollSCM('* * * * *') // Poll Git every minute, or configure webhook
    }

    stages {

        stage('Checkout Code') {
            steps {
                // Checkout only if app files changed (not Dockerfile/infra)
                script {
                    def changes = changelog scm: [$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: 'https://github.com/yourusername/yourrepo.git', credentialsId: env.GIT_CREDENTIALS]]]
                    def runBuild = false
                    for (change in changes) {
                        if (!(change.path.startsWith("infra/") || change.path == "Dockerfile")) {
                            runBuild = true
                            break
                        }
                    }
                    if (!runBuild) {
                        echo "No relevant changes detected. Skipping build."
                        currentBuild.result = 'NOT_BUILT'
                        return
                    }
                }

                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']],
                          doGenerateSubmoduleConfigurations: false,
                          extensions: [],
                          userRemoteConfigs: [[
                              url: 'https://github.com/yourusername/yourrepo.git',
                              credentialsId: env.GIT_CREDENTIALS
                          ]]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${env.IMAGE_NAME}:latest")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKER_CREDENTIALS) {
                        docker.image("${env.IMAGE_NAME}:latest").push()
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully. Docker image pushed as latest."
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}

