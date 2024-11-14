@Library("shared-library@master") _

pipeline {
    agent{
        label "macos"
    }

    environment {
    	PATH = "/Applications/Docker.app/Contents/Resources/bin:${env.PATH}"
        COMPOSE_VALUE = getCompose();
    }

    stages {
        stage("info") {
			steps {
			    sh 'docker -v'
			}
		}

        stage("Docker Down") {
            when {
                expression { env.COMPOSE_VALUE == "DOWN" }
            }

            steps {
                sh '''
                    echo 'DOCKER DOWN'
                    docker compose stop
                '''
            }
        }

        stage("Docker Up") {
            when {
                expression { env.COMPOSE_VALUE == "UP" }
            }

            steps {
                sh '''
                    echo 'DOCKER UP'
                    docker compose start
                '''
            }
        }

        stage("Docker check") {
            when {
                expression { env.COMPOSE_VALUE == "UP" }
            }
            
            steps {
                sh '''
                    chmod 777 servercheck.sh
                    ./servercheck.sh
                '''
            }
        }
    }
}