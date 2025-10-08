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
            when { expression { env.SHOULD_SKIP != "true" } }
            steps {
                script {
                    // Use the stored Git credentials to push the manifest change
                    withCredentials([usernamePassword(credentialsId: env.GIT_CREDENTIALS, usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                        sh """
                            set -euo pipefail
                            echo "Configuring push remote with credentials (masked)..."
                            git remote set-url origin https://${GIT_USER}:${GIT_PASS}@github.com/Ayushmaan7/delta_project.git
                            git fetch origin
                            git checkout main

                            # Prefer yq if available (safe YAML edit). Fallback to awk-based edit.
                            if command -v yq >/dev/null 2>&1; then
                                echo "Using yq to update ${MANIFESTS_PATH}/values.yaml"
                                # yq v4 syntax; this will set image.tag to the build number
                                yq eval --inplace '.image.tag = strenv(BUILD_NUMBER)' ${MANIFESTS_PATH}/values.yaml
                            else
                                echo "yq not found — using awk fallback to update ${MANIFESTS_PATH}/values.yaml"
                                awk -v TAG="${BUILD_NUMBER}" 'BEGIN{in_image=0} /^image:/{print; in_image=1; next} in_image && /^\\s*repository:/{print; next} in_image && /^\\s*tag:/{print "  tag: " TAG; in_image=0; next} {print}' ${MANIFESTS_PATH}/values.yaml > ${MANIFESTS_PATH}/values.yaml.tmp
                                mv ${MANIFESTS_PATH}/values.yaml.tmp ${MANIFESTS_PATH}/values.yaml
                            fi

                            # show diff for logs (masked)
                            git --no-pager diff -- ${MANIFESTS_PATH}/values.yaml || true

                            git add ${MANIFESTS_PATH}/values.yaml
                            git config user.email "jenkins@ci.example"
                            git config user.name "Jenkins CI"
                            git commit -m "ci: bump image to ${env.BUILD_NUMBER} [ci skip]" || echo "No changes to commit"
                            git push origin HEAD:main
                        """
                    }
                }
            }
        }

        // (optional) you could add a 'Notify ArgoCD' stage here if you use API-trigger instead of relying on Git event
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

