pipeline {
    agent { label "${LABEL_NAME}" }

    environment {
        IMAGE_NAME = "shikohzaidi/webimg"
        IMAGE_TAG  = "${BUILD_NUMBER}"
        DOCKER_CREDS = credentials('dockerhub-creds')
        CONTAINER_NAME = "webapp"
    }

    stages {

        stage('Fetch Code') {
            steps {
                git url:"https://github.com/shikoh-zaidi/training_solution.git", branch:"master"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME:$IMAGE_TAG .
                '''
            }
        }

        stage('Image Check') {
            steps {
                sh '''
                trivy image --severity CRITICAL --exit-code 0 $IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }

        
        stage('Login to Docker Hub') {
            steps {
                sh '''
                echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin
                '''
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                sh '''
                docker push $IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''

                docker stop webapp || true
                docker rm webapp || true

                docker run -d --name $CONTAINER_NAME -p 5000:5000 $IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs."
        }
    }
}
