pipeline {
    agent any

    environment {
        IMAGE_NAME = 'ayushmaan7/mini-airbnb'
        DOCKER_CREDENTIALS = 'dockerhub-creds'
        GIT_CREDENTIALS = 'github-creds'
    }

    options {
        skipDefaultCheckout()
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    doGenerateSubmoduleConfigurations: false,
                    userRemoteConfigs: [[
                        url: 'https://github.com/Ayushmaan7/delta_project.git',
                        credentialsId: env.GIT_CREDENTIALS
                    ]]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build with both latest and build number tags
                    def buildNumberTag = "${env.BUILD_NUMBER}"
                    docker.build("${env.IMAGE_NAME}:${buildNumberTag}")
                    docker.build("${env.IMAGE_NAME}:latest")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKER_CREDENTIALS) {
                        def buildNumberTag = "${env.BUILD_NUMBER}"
                        docker.image("${env.IMAGE_NAME}:${buildNumberTag}").push()
                        docker.image("${env.IMAGE_NAME}:latest").push()
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully. Docker images pushed: latest and ${env.BUILD_NUMBER}"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}

