def gitUrl = "https://github.com/waycambas8/service-master.git"
def service = "service-master-app"
def serviceNginx = "service-master-nginx"
def directory = "service-master"
def nameContainer = "app-master"

pipeline {
    agent any
    environment {
        GIT_CREDENTIALS = credentials('github-login-token')
    }
    stages {
        stage('Clone') {
            steps {
                script {
                    cleanWs()
                    checkout([$class: 'GitSCM', branches: [[name: 'main']], userRemoteConfigs: [[credentialsId: 'github-login-token', url: "${gitUrl}"]]])
                    echo "success step 1"
                }
            }
        }

        stage('SSH Client') {
            steps {
                sshagent(['ssh-app']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ec2-user@13.250.52.15 "
                            if [ ! -d ${directory} ]; then
                                git clone ${gitUrl} ${directory}
                            fi
                            cd ${directory} && git pull origin main

                            git fetch --tags
                            RELEASE_TAG=\$(git describe --tags --abbrev=0)
                            echo \"Current release tag: \$RELEASE_TAG\"

                            docker-compose -f development-compose.yml --env-file .docker/.env.docker up -d --build
                        "
                    """
                }
                echo "success step 2"
            }
        }
    }
}
