pipeline {
    agent any 

    tools {
        jdk 'JAVA'
        maven 'MAVEN'
        nodejs 'NODEJS'
    }

    environment {
        SCANNER_HOME = tool 'SonarQube Scanner 7.2.0.5079'   // Replace with your scanner tool name
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
                    credentialsId: 'GITHUB_CREDENTIALS',
                    url: 'https://github.com/teju2707/onlinegame.git'
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SCANNER_HOME = tool 'SonarQube Scanner 7.2.0.5079'
            }
            steps {
                withSonarQubeEnv('SonarQubeDev') {
                    withCredentials([string(credentialsId: 'SONAR', variable: 'SONAR_TOKEN')]) {
                        sh """${SCANNER_HOME}/bin/sonar-scanner \
                            -Dsonar.projectKey=onlinegame \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=http://<YOUR_SONARQUBE_SERVER>:9000 \
                            -Dsonar.login=${SONAR_TOKEN}"""
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}