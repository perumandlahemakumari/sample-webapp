pipeline {
    agent any

    tools {
        maven 'maven3'
    }

    environment {
        GIT_REPO_NAME = "sample-webapp"
        GIT_USER_NAME = "perumandlahemakumari"
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Cloning GitHub Repo'
                git branch: 'main', url: "https://github.com/${GIT_USER_NAME}/${GIT_REPO_NAME}.git"
            }
        }

        stage('Sonar Scan') {
            steps {
                echo 'Scanning project with SonarQube'
                sh 'ls -ltr'

                sh '''mvn sonar:sonar \\
                      -Dsonar.host.url=http://44.210.116.12:9000 \\
                      -Dsonar.login=squ_a46b6947d43a812180415ff94219120d2ddebcea'''
            }
        }

        stage('Build Artifact') {
            steps {
                echo 'Building Artifact'
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker Image'
                sh 'docker build -t ${GIT_USER_NAME}/${GIT_REPO_NAME}:${BUILD_NUMBER} .'
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]) {
                        sh 'docker login -u ${GIT_USER_NAME} -p ${dockerhub}'
                    }
                    sh 'docker push ${GIT_USER_NAME}/${GIT_REPO_NAME}:${BUILD_NUMBER}'
                }
            }
        }

        stage('Update Deployment File') {
            steps {
                echo 'Updating Kubernetes deployment file with new image version'
                withCredentials([string(credentialsId: 'githubtoken', variable: 'githubtoken')]) {
                    sh '''
                        git config user.email "your-email@example.com"
                        git config user.name "Your Name"
                        sed -i "s|image: ${GIT_USER_NAME}/${GIT_REPO_NAME}:.*|image: ${GIT_USER_NAME}/${GIT_REPO_NAME}:${BUILD_NUMBER}|g" deploymentfiles/deployment.yml
                        git add deploymentfiles/deployment.yml
                        git commit -m "Update image tag to version ${BUILD_NUMBER}"
                        git push https://${githubtoken}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                    '''
                }
            }
        }
    }
}
