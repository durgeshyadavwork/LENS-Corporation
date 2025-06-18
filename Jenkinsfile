
pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['test', 'prod'], description: 'Choose the deployment environment')
    }

    environment {
        DOCKER_IMAGE = 'dugreshyadav/lens_corporation'
        ASG_NAME     = 'my_asg'  // Match this with your Terraform ASG name
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
                // You must also configure JUnit plugin and use proper output XML file
                // junit 'result.xml'  // Optional if using test reports
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
                    sh """
                        echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                        docker push $DOCKER_IMAGE:$IMAGE_TAG
                    """
                }
            }
        }

        stage('Trigger ASG Instance Refresh') {
            steps {
                sh """
                    aws autoscaling start-instance-refresh \
                      --auto-scaling-group-name ${ASG_NAME} \
                      --preferences '{"MinHealthyPercentage": 50, "InstanceWarmup": 300}'
                """
            }
        }

        stage('Terraform Apply') {
            steps {
                sh """
                    cd terraform/
                    terraform init
                    terraform apply -auto-approve \
                        -var="environment=${params.ENVIRONMENT}" \
                        -var="image_tag=${IMAGE_TAG}"
                """
            }
        }

        stage('Cleanup') {
            steps {
                sh "docker rmi $DOCKER_IMAGE:$IMAGE_TAG || true"
            }
        }
    }
}




// pipeline {
//     agent any
//     parameters {
//         choice(name: 'ENVIRONMENT', choices: ['test', 'prod'], description: 'Choose the deployment environment')
//     }


//      environment {
//         DOCKER_IMAGE = 'dugreshyadav/lens_corporation'
//         IMAGE_TAG = "${params.ENVIRONMENT}-${BUILD_NUMBER}"
//         ASG_NAME = 'my_asg' // Match this with your Terraform ASG
//     }

//     stages {
//         stages {

//         stage('Print Environment Config') {
//             steps {
//                 echo "Deploying to: ${params.ENVIRONMENT}"
//                 echo "Docker Image Tag: ${IMAGE_TAG}"
//             }
//         }

//         stage('Set Config Based on Environment') {
//             steps {
//                 script {
//                     env.TARGET_HOST = (params.ENVIRONMENT == 'test') ? TEST_HOST : PROD_HOST
//                     env.IMAGE_TAG = "${params.ENVIRONMENT}-${BUILD_NUMBER}"
//                 }
//             }
//         }

//         stage('Clone Repo') {
//             steps {
//                 git branch: 'application',
//                 url: 'https://github.com/durgeshyadavwork/LENS-Corporation.git'
//             }
//         }

//         stage('Run Unit Tests') {
//             steps {
//                 sh '''
//                     pip install pytest
//                     pytest > result.txt || true
//                 '''
//                 junit 'result.xml' 
//             }
//         }

//         stage('Build Docker Image') {
//             steps {
//                 script {
//                     sh "docker build -t $DOCKER_IMAGE:${BUILD_NUMBER} ."
//                 }
//             }
//         }

//         stage('Push Docker Image') {
//             steps {
//                 withCredentials([
//                     usernamePassword(
//                         credentialsId: 'docker-hub-creds',
//                         usernameVariable: 'DOCKERHUB_USER',
//                         passwordVariable: 'DOCKERHUB_PASS'
//                     )
//                 ]) {
//                     sh """
//                         echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
//                         docker push $DOCKER_IMAGE:${IMAGE_TAG}
//                     """
//                 }
//             }
//         }


//         stage('Trigger ASG Instance Refresh') {
//             steps {
//                 sh """
//                     aws autoscaling start-instance-refresh \
//                       --auto-scaling-group-name ${ASG_NAME} \
//                       --preferences '{"MinHealthyPercentage": 50, "InstanceWarmup": 300}'
//                 """
//             }
//         }

//         stage('Terraform Apply') {
//     steps {
//         sh """
//             cd terraform/
//             terraform init
//             terraform apply -auto-approve -var="environment=${params.ENVIRONMENT}" -var="image_tag=${params.ENVIRONMENT}-${BUILD_NUMBER}"
//         """
//          } }



//         stage('Cleanup') {
//             steps {
//                 sh 'docker rmi $DOCKER_IMAGE:${BUILD_NUMBER}'
//             }
//         }
//     }

    
// }

// }




// pipeline {
//     agent any

//     parameters {
//         choice(name: 'ENVIRONMENT', choices: ['test', 'prod'], description: 'Choose the deployment environment')
//     }

//     environment {
//         DOCKER_IMAGE = 'dugreshyadav/lens_corporation'
//         IMAGE_TAG = "${params.ENVIRONMENT}-${BUILD_NUMBER}"
//         ASG_NAME = 'my_asg' // Match this with your Terraform ASG
//     }

//     stages {

//         stage('Print Environment Config') {
//             steps {
//                 echo "Deploying to: ${params.ENVIRONMENT}"
//                 echo "Docker Image Tag: ${IMAGE_TAG}"
//             }
//         }

//         stage('Clone Repository') {
//             steps {
//                 git branch: 'application',
//                 url: 'https://github.com/durgeshyadavwork/LENS-Corporation.git'
//             }
//         }

//         stage('Run Unit Tests') {
//             steps {
//                 sh '''
//                     pip install pytest
//                     pytest --junitxml=result.xml || true
//                 '''
//                 junit 'result.xml'
//             }
//         }

//         stage('Build Docker Image') {
//             steps {
//                 script {
//                     sh "docker build -t $DOCKER_IMAGE:${IMAGE_TAG} ."
//                 }
//             }
//         }

//         stage('Push Docker Image') {
//             steps {
//                 withCredentials([
//                     usernamePassword(
//                         credentialsId: 'docker-hub-creds',
//                         usernameVariable: 'DOCKERHUB_USER',
//                         passwordVariable: 'DOCKERHUB_PASS'
//                     )
//                 ]) {
//                     sh """
//                         echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
//                         docker push $DOCKER_IMAGE:${IMAGE_TAG}
//                     """
//                 }
//             }
//         }

//         stage('Trigger ASG Instance Refresh') {
//             steps {
//                 sh """
//                     aws autoscaling start-instance-refresh \
//                       --auto-scaling-group-name ${ASG_NAME} \
//                       --preferences '{"MinHealthyPercentage": 50, "InstanceWarmup": 300}'
//                 """
//             }
//         }

//         stage('Cleanup Local Image') {
//             steps {
//                 sh 'docker rmi $DOCKER_IMAGE:${IMAGE_TAG} || true'
//             }
//         }
//     }

    
// }
