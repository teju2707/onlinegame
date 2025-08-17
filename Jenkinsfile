pipeline {
    agent any 

    tools {
        jdk 'JAVA'
        maven 'MAVEN'
        nodejs 'NODEJS'
    }

    environment {
        SCANNER_HOME = tool 'SONAR'   // Replace with your scanner tool name
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
                SCANNER_HOME = tool 'SonarQubeScanner'
            }
            steps {
                withSonarQubeEnv('SonarQubeDev') {
                    // Standard SonarScanner CLI command for JS/Node projects
                    sh """${SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.projectKey=onlinegame \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://<YOUR_SONARQUBE_SERVER>:9000 \
                        -Dsonar.login=<YOUR_SONARQUBE_TOKEN>"""
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