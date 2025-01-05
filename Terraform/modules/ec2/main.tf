resource "aws_instance" "ec2-prueba-final" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id
  associate_public_ip_address = true
  key_name                    = var.key_name
  disable_api_termination = true

metadata_options {
    http_tokens = "required"
  }
  
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y git 

    # Clonar el repositorio de tu aplicación
    git clone https://github.com/notdanielrojas/prueba-final-devops.git

    # Instalar dependencias 
    cd prueba-final-devops
    npm install

    # Instalar PM2
    sudo npm install pm2 -g

    # Iniciar la aplicación con PM2
    pm2 start npm --name "landingpage-yossequiropractica" -- start

    # Guardar la lista de procesos de PM2
    pm2 save
  EOF

  tags = {
    Name = var.instance_name
  }

  # Conexión SSH
  connection {
    type = "ssh"
    user = "notdanielrojas"
    host = self.public_ip
    private_key = file("\\\\wsl.localhost\\Ubuntu\\media\\keys\\keypair-ssh.pem")
  }
}