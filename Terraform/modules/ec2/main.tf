resource "aws_instance" "ec2-prueba-final" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id
  associate_public_ip_address = true
  key_name                    = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y git curl nodejs npm

    # Clonar el repositorio
    git clone https://github.com/notdanielrojas/prueba-final-devops.git /home/ubuntu/app

    # Instalar dependencias
    cd /home/ubuntu/app
    npm install

    # Instalar PM2 y ejecutar la app
    sudo npm install pm2 -g
    pm2 start npm --name "landingpage-yossequiropractica" -- start
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