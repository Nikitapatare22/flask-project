pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                // Cloning the main branch of the repository
                git branch: 'main', url: 'https://github.com/Nikitapatare22/flask-project'
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
                withCredentials([string(credentialsId: 'docker-hub-credentials', variable: 'DOCKER_HUB_TOKEN')]) {
                    sh """
                    echo \$DOCKER_HUB_TOKEN | docker login -u your-docker-username --password-stdin
                    docker tag flask-app:latest your-docker-username/flask-app:latest
                    docker push your-docker-username/flask-app:latest
                    """
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes...'
                sh """
                kubectl apply -f k8s-deployment.yaml
                kubectl apply -f k8s-service.yaml
                """
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
