pipeline {
    agent any
    environment {
        REPO_URL = 'https://github.com/tuusuario/aws-django-react-portfolio.git'
        EC2_HOST = 'ubuntu@15.188.55.56'
        SSH_KEY = credentials('EC2-SSH-KEY')
    }
    stages {
        stage('Clonar Repositorio') {
            steps {
                git branch: 'Produccion', url: "${REPO_URL}"
            }
        }
	stage('Creando Entorno Pruebas'){
	    steps {
		script {
		    sh 'pwd'

                    // Asegurar que Python3 y pip están disponibles
                    sh 'python3.9 --version'
                    sh 'python3.9 -m pip --version'

                    // Crear un entorno virtual

                    sh """
                    if [ ! -d "${VENV_PATH}" ]; then
                        python3.9 -m venv ${VENV_PATH}
                    fi
                    """

                    // Instalar pip en el entorno virtual

                    sh """
                    . ${VENV_PATH}/bin/activate
                    python3.9 -m pip install --upgrade pip
                    deactivate
                    """
		}
	    }
	}
        stage('Pruebas') {
            steps {
                sh 'python3 -m unittest discover -s backend/tests'
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
