pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['test', 'prod'], description: 'Choose the deployment environment')
    }

    environment {
        DOCKER_IMAGE = 'dugreshyadav/lens_corporation'
        AWS_DEFAULT_REGION = 'ap-south-1'
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {

        stage('Set Config Based on Environment') {
            steps {
                script {
                    env.IMAGE_TAG = "${params.ENVIRONMENT}-${BUILD_NUMBER}"
                }
            }
        }

        stage('Print Environment Config') {
            steps {
                echo "Deploying to: ${params.ENVIRONMENT}"
                echo "Docker Image Tag: ${env.IMAGE_TAG}"
            }
        }

        stage('Clone Repo') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/durgeshyadavwork/LENS-Corporation.git'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh '''
                    pip install pytest
                    pytest > result.txt || true
                '''
                // Optionally use junit if you have XML reports
                // junit 'result.xml'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $DOCKER_IMAGE:$IMAGE_TAG ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-hub-creds',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_PASS'
                    )
                ]) {
                    sh '''
                        echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                        docker push $DOCKER_IMAGE:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
        sh """
            cd Terraform/
            terraform init
            terraform apply -auto-approve \
                -var="environment=${params.ENVIRONMENT}" \
                -var="image_tag=${IMAGE_TAG}"
        """
    }
        }
        




        stage('Trigger ASG Refresh') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        export AWS_DEFAULT_REGION=ap-south-1

                        aws autoscaling start-instance-refresh \
                            --auto-scaling-group-name my_asg \
                            --preferences '{"MinHealthyPercentage": 50, "InstanceWarmup": 300}'
                    '''
                }
            }
        }

        stage('Cleanup') {
            steps {
                sh "docker rmi $DOCKER_IMAGE:$IMAGE_TAG || true"
            }
        }
    }
}
