pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning the repository...'
                withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'GITHUB_USERNAME', passwordVariable: 'GITHUB_TOKEN')]) {
                    sh """
                    git config --global url.https://\$GITHUB_USERNAME:\$GITHUB_TOKEN@github.com/.insteadOf https://github.com/
                    git clone -b main https://github.com/Nikitapatare22/flask-project.git
                    """
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker Image...'
                sh 'docker build -t flask-app:latest .'
            }
        }
        stage('Push Docker Image') {
            steps {
                echo 'Pushing Docker Image...'
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh """
                    echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin
                    docker tag flask-app:latest \$DOCKER_USERNAME/flask-app:latest
                    docker push \$DOCKER_USERNAME/flask-app:latest
                    """
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Configuring GCP Service Account...'
                withCredentials([file(credentialsId: 'gcp-service-account', variable: 'GCP_CREDENTIALS')]) {
                    sh """
                    gcloud auth activate-service-account --key-file=\$GCP_CREDENTIALS
                    kubectl apply -f k8s-deployment.yaml
                    kubectl apply -f k8s-service.yaml
                    """
                }
            }
        }
        stage('Setup SSH Connection') {
            steps {
                echo 'Setting up SSH connection...'
                withCredentials([sshUserPrivateKey(credentialsId: 'slave', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                    sh """
                    ssh -i \$SSH_KEY \$SSH_USER@remote-server 'echo SSH Connection Established'
                    """
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
