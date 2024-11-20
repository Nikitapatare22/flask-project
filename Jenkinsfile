pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "nikitapatare/flask-app:latest"
        DOCKER_REGISTRY_CREDENTIALS = 'dockerhub-credentials' // Replace with your Jenkins credential ID
    }
    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning repository...'
                git branch: 'main', url: 'https://github.com/Nikitapatare22/flask-project'
            }
        }
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker Image...'
                script {
                    def dockerHome = tool name: 'Docker', type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'
                    env.PATH = "${dockerHome}/bin:${env.PATH}"
                }
                sh '''
                    docker build -t ${DOCKER_IMAGE} .
                '''
            }
        }
        stage('Push Docker Image') {
            steps {
                echo 'Pushing Docker Image to DockerHub...'
                withCredentials([usernamePassword(credentialsId: "${DOCKER_REGISTRY_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}
                    '''
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes...'
                script {
                    sh '''
                        kubectl apply -f k8s/deployment.yaml
                        kubectl apply -f k8s/service.yaml
                    '''
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline completed!'
        }
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
