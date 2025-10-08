pipeline {
    agent any

    environment {
        IMAGE_NAME = 'ayushmaan7/mini-airbnb'
        DOCKER_CREDENTIALS = 'dockerhub-creds'
        GIT_CREDENTIALS = 'github-creds'   // must be username+token or username+password
        MANIFESTS_PATH = 'deployment/helmchart' // path to helm chart that ArgoCD watches
    }

    options {
        skipDefaultCheckout()
        // you can add timestamps(), buildDiscarder(...) etc.
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    env.SHOULD_SKIP = "false"

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

                    def changesRaw = sh(script: "git diff --name-only ${previousCommit} ${currentCommit} || true", returnStdout: true).trim()
                    def changes = changesRaw ? changesRaw.split('\\n') : []

                    def blockingFiles = ['Jenkinsfile', 'Dockerfile']
                    def blockingDirs = ['infra/', 'deployment/']

                    boolean onlyBlockingChanges = true
                    for (file in changes) {
                        if (!blockingFiles.contains(file) && !blockingDirs.any { file.startsWith(it) }) {
                            onlyBlockingChanges = false
                            break
                        }
                    }

                    if (onlyBlockingChanges && changes.size() > 0) {
                        env.SHOULD_SKIP = "true"
                        echo "Pipeline skipped: Only Jenkinsfile, Dockerfile, infra/ or deployment/ changes detected."
                    } else {
                        echo "Proceeding with build; changes found: ${changes}"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            when { expression { env.SHOULD_SKIP != "true" } }
            steps {
                script {
                    def buildNumberTag = "${env.BUILD_NUMBER}"
                    docker.build("${env.IMAGE_NAME}:${buildNumberTag}")
                    docker.build("${env.IMAGE_NAME}:latest")
                }
            }
        }

        stage('Push Docker Image') {
            when { expression { env.SHOULD_SKIP != "true" } }
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKER_CREDENTIALS) {
                        def buildNumberTag = "${env.BUILD_NUMBER}"
                        docker.image("${env.IMAGE_NAME}:${buildNumberTag}").push()
                        docker.image("${env.IMAGE_NAME}:latest").push()
                    }

                    // Cleanup local images (best-effort)
                    sh """
                        docker rmi -f ${env.IMAGE_NAME}:${env.BUILD_NUMBER} || true
                        docker rmi -f ${env.IMAGE_NAME}:latest || true
                    """
                }
            }
        }

        // --- NEW STAGE: update the helm chart in Git that ArgoCD watches ---
        stage('Update Manifests Repo') {
    when {
        expression { env.SHOULD_SKIP != "true" }
    }
    steps {
        script {
            withCredentials([usernamePassword(credentialsId: env.GIT_CREDENTIALS, usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                sh '''#!/bin/bash
                set -e

                echo "=== Cloning repo to update manifest ==="
                rm -rf delta_project || true
                git clone https://$GIT_USER:$GIT_PASS@github.com/Ayushmaan7/delta_project.git
                cd delta_project

                echo "=== Updating image tag in Helm values.yaml ==="
                sed -i "s|image: ayushmaan7/mini-airbnb:.*|image: ayushmaan7/mini-airbnb:${BUILD_NUMBER}|g" deployment/helmchart/values.yaml

                echo "=== Commit and push changes ==="
                git config user.email "jenkins@ci.com"
                git config user.name "Jenkins CI"
                git add deployment/helmchart/values.yaml
                git commit -m "Update image tag to ${BUILD_NUMBER}"
                git push https://$GIT_USER:$GIT_PASS@github.com/Ayushmaan7/delta_project.git main

                echo "✅ Manifest updated successfully."
                '''
            }
        }
    }
}


    post {
        success {
            echo "Pipeline finished successfully."
        }
        failure {
            echo "Pipeline failed — check console output."
        }
    }
}

