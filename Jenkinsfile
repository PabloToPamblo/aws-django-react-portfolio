pipeline {
    agent any
    environment {
        REPO_URL = 'https://github.com/PabloToPamblo/aws-django-react-portfolio.git'
        EC2_HOST = 'ubuntu@15.188.55.56'
        SSH_KEY = credentials('EC2-SSH-KEY')
    }
    stages {
        stage('Clonar Repositorio') {
            steps {
                git branch: 'Produccion', url: "${REPO_URL}"
            }
        }
        stage('Pruebas') {
            steps {
                script {
                    // Asegurar que Python3 y pip están disponibles
                    sh 'python3 --version'
                    sh 'pip3 --version'

                    // Instalar dependencias del proyecto desde requirements.txt
                    sh 'pip3 install --user -r requirements.txt'

                    // Ejecutar flake8 con la configuración de setup.cfg
                    sh 'flake8 backend'
                }
            }
        }
        stage('Desplegar en EC2') {
            steps {
                sshagent(['EC2-SSH-KEY']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ${EC2_HOST} <<EOF
                        cd /home/ubuntu/aws-django-react-portfolio
                        git pull origin Produccion
                        source backend/venv/bin/activate
                        pip install -r backend/requirements.txt
                        sudo systemctl restart gunicorn
                        sudo systemctl restart nginx
                    EOF
                    '''
                }
            }
        }
    }
}
