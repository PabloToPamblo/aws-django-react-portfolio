pipeline {
    agent any
    environment {
        REPO_URL = 'https://github.com/PabloToPamblo/aws-django-react-portfolio.git'
        EC2_HOST = 'ubuntu@15.188.55.56'
        SSH_KEY = credentials('EC2-SSH-KEY')
        VENV_PATH = 'venv'  //Ruta entorno virtual
    }
    stages {
        stage('Clonar Repositorio') {
            steps {
                git branch: 'Produccion', url: "${REPO_URL}"
            }
        }
        stage('Creando Entorno Virtual') {
            steps {
                script {
		    sh 'pwd'

                    // Asegurar que Python3 y pip están disponibles
                    sh 'python3.9 --version'
                    sh 'python3.9 -m pip --version'
                    
                    // Crear un entorno virtual

                    sh 'python3.9 -m venv venv'

                    // Instalar pip en el entorno virtual

                    sh """
                    . venv/bin/activate
                    python3.9 -m pip install --upgrade pip
                    deactivate
                    """
                }
            }
        }

	stage('Dependency install') {
	    steps {
	        script {
		    // Activar el entorno virtual y ejecutar flake8
                    sh """
                    . venv/bin/activate
                    python3.9 -m pip install -r backend/requirements.txt
                    flake8 backend/backend
                    deactivate
                    """
		}
	    }
        }
    }
}
