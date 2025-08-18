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
                SCANNER_HOME = tool 'SONAR'   // 1 -> SONAR scanner tool name in Jenkins global tools
            }
            steps {
                withSonarQubeEnv('SONAR') {   // 2 -> SonarQube server name (configure in Jenkins > Configure System)
                    withCredentials([string(credentialsId: 'SONARQUBE', variable: 'SONAR_TOKEN')]) { // 3 -> token stored in Jenkins credentials
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
                    waitForQualityGate abortPipeline: false
                }
            }
        }

        stage('Install dependencies') {
            steps {
                sh 'npm install'
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
    }  // 🔴 <-- closing braces for stages
}      // 🔴 <-- closing braces for pipeline
