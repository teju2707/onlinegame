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
                    credentialsId: 'GITHUB_CREDENTIALS',
                    url: 'https://github.com/teju2707/onlinegame.git'
            }
        }
    }
}
