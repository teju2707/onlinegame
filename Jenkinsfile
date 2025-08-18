pipeline {
    agent any

    tools {
        jdk 'JAVA'
        maven 'MAVEN'
        // NodeJS tool only needed for SonarQube (if scanner requires Node)
        nodejs 'NODEJS24'
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

        stage('Install dependencies & Test (Dockerized)') {
            steps {
                sh '''
                    docker run --rm -v $PWD:/app -w /app node:24-alpine \
                    sh -c "npm install && npm test"
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
    }
}
