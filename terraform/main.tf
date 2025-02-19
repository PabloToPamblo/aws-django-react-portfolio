# Definir el proveedor (AWS)
provider "aws" {
  region = "eu-west-3"
}

# Crear una instancia EC2
resource "aws_instance" "web_server" {
  ami           = "ami-06e02ae7bdac6b938"  # AMI eu-west-3
  instance_type = "t2.micro"

  tags = {
    Name = "DjangoServer"
  }
}

# Creamos security group para HTTP y SSH

resource "aws_security_group" "web_sg" {
  name        = "web_server_sg"
  description = "Habilita HTTP y SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite SSH desde cualquier IP (no seguro en producción)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfico HTTP
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfico HTTPS
  }
}

# Creamos un disco S3

resource "aws_s3_bucket" "static_files" {
  bucket = "django-static-files-pablo"
  acl    = "private"
}

# Extraemos secret pass para RDS

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "mydb/password"
}

# Creamos base de datos RDS

resource "aws_db_instance" "postgres" {
  identifier        = "django-postgres-db"
  allocated_storage = 20
  engine           = "postgres"
  instance_class   = "db.t3.micro"
  username        = "dbadmin"
  password        = data.aws_secretsmanager_secret_version.db_password.secret_string
  publicly_accessible = false
}

