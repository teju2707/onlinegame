pipeline {
    agent any

    tools {
        jdk 'JAVA'
        maven 'MAVEN'
        nodejs 'NODEJS'
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
                SCANNER_HOME = tool 'SONAR'  // 1
            }
            steps {
                withSonarQubeEnv('SONAR') {                   // 2
                    withCredentials([string(credentialsId: 'SONARQUBE', variable: 'SONAR_TOKEN')]) { // 3
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
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Install dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Owasp Scan') {
            steps {
                dependencyCheck additionalArguments: '', nvdCredentialsId: 'SONARQUBE', odcInstallation: 'OWASP'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
    }
}
