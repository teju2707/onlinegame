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
                SCANNER_HOME = tool 'SonarQubeScanner'   // Replace with your scanner tool name
            }
            steps {
                withSonarQubeEnv('SonarQubeDev') {   // Replace with your SonarQube server name
                    sh """${SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.projectKey=onlinegame \
                        -Dsonar.sources=. \
                        -Dsonar.host.url= http://3.80.156.67:9000
                        -Dsonar.login= SONAR"""
                }
            }
        }
    }
}
