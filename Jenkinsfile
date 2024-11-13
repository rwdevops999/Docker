@library("shared-library@1.0") _

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
                expression {
                    ${COMPOSE_VALUE} === "DOWN"
                }
            }

            steps {
                sh '''
                    echo 'DOCKER DOWN'
                    // docker compose down
                '''
            }
        }

        stage("Docker Up") {
            when {
                expression {
                    ${COMPOSE_VALUE} === "UP"
                }
            }

            steps {
                sh '''
                    echo 'DOCKER UP'
                    // docker compose up
                '''
            }
        }
    }

    post{
        success{
    	    mailTo(to: 'rudi.welter@gmail.com', attachLog: false)
        }
        failure{
    	    mailTo(to: 'rudi.welter@gmail.com', attachLog: true)
        }
    }
}