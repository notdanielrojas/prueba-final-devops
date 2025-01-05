resource "aws_instance" "ec2-prueba-final" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id
  associate_public_ip_address = true
  key_name                    = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    echo "Instalando Nginx y configurando servidor para archivos estáticos..."

    # Instalar Nginx usando amazon-linux-extras
    sudo amazon-linux-extras enable nginx1
    sudo yum install -y nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx

    # Crear directorio para la aplicación si no existe
    sudo mkdir -p /var/www/landingpage

    # Copiar archivos estáticos a la carpeta web
    sudo cp -r /home/ec2-user/app/App/* /var/www/landingpage/

    # Crear la configuración de Nginx
    sudo mkdir -p /etc/nginx/conf.d
    sudo tee /etc/nginx/conf.d/landingpage.conf > /dev/null <<EOL
    server {
        listen 80;

        # Raíz de la aplicación
        root /var/www/landingpage;
        index index.html;

        # Configuración para servir archivos estáticos
        location / {
            try_files \$uri \$uri/ =404;
        }

        # Manejo de errores
        error_page 404 /404.html;
    }
    EOL

    # Recargar configuración de Nginx
    sudo nginx -s reload
  EOF

  tags = {
    Name = var.instance_name
  }

  # Conexión SSH
  connection {
    type = "ssh"
    user = "ec2-user"
    host = self.public_ip
    private_key = file("/media/keys/keypair-ssh.pem")
  }
}
