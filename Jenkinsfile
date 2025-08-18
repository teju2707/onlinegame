pipeline {
    agent any

    tools {
        jdk 'JAVA'
        maven 'MAVEN'
        nodejs 'NODEJS'  // Use existing tool name
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/teju2707/onlinegame.git',
                    credentialsId: 'github-credentails'
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SCANNER_HOME = tool 'SONAR'
            }
            steps {
                withSonarQubeEnv('SONAR') {
                    withCredentials([string(credentialsId: 'SONARQUBE', variable: 'SONAR_TOKEN')]) {
                        sh """
                            ${SCANNER_HOME}/bin/sonar-scanner \
                            -Dsonar.projectKey=BingoOnlineGame \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=http://34.227.112.104:9000 \
                            -Dsonar.login=${SONAR_TOKEN}
                        """
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 15, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Install & Test (Docker)') {
            steps {
                sh '''
                    docker run --rm -v "$WORKSPACE":/app -w /app node:24-alpine sh -c "npm ci && npm test"
                '''
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '',
                                nvdCredentialsId: 'SONARQUBE',
                                odcInstallation: 'OWASP'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage('Trivy scan') {
            steps {
                sh 'trivy fs . > trivy-report.txt'
            }
        }

        stage('Build & Push to ECR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-credentail', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    sh '''
                        # Configure AWS
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set default.region us-east-1

                        # Login to ECR
                        aws ecr get-login-password --region us-east-1 | \
                        docker login --username AWS --password-stdin 935598635277.dkr.ecr.us-east-1.amazonaws.com

                        # Build Docker image
                        docker build -t jenkins-pipeline/node.js .

                        # Tag for ECR
                        docker tag jenkins-pipeline/node.js:latest 935598635277.dkr.ecr.us-east-1.amazonaws.com/jenkins-pipeline/node.js:latest

                        # Push to ECR
                        docker push 935598635277.dkr.ecr.us-east-1.amazonaws.com/jenkins-pipeline/node.js:latest
                    '''
                }
            }
        }
    }
}
