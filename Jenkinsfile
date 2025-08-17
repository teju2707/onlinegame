pipeline {
    agent any

    tools {
        jdk 'JDK 17'
        nodejs 'node16'
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
                SCANNER_HOME = tool 'SonarQubeScanner'
            }
            steps {
                withSonarQubeEnv('SonarQubeDev') { // Use the SonarQube server name from Jenkins Configure System
                    withCredentials([string(credentialsId: 'SONAR', variable: 'SONAR_TOKEN')]) {
                        sh """
                            ${SCANNER_HOME}/bin/sonar-scanner \
                            -Dsonar.projectKey=onlinegame \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=http://<YOUR_SONARQUBE_SERVER>:9000 \
                            -Dsonar.login=${SONAR_TOKEN}
                        """
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
