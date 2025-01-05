# Proyecto de Despliegue de Aplicaciones en AWS con GitHub Actions, Docker, Snyk, y Terraform

Este proyecto automatiza el proceso de construcción, escaneo de seguridad y despliegue de una aplicación en AWS usando **GitHub Actions**, **Docker**, **Snyk**, y **Terraform**.

## Descripción

El pipeline de GitHub Actions está configurado para ejecutar los siguientes trabajos:

1. **Build y Push de Docker**:
   - Compila la imagen Docker utilizando un Dockerfile multistage.
   - Realiza el push de la imagen construida a Amazon ECR (Elastic Container Registry).

2. **Escaneo de Seguridad**:
   - Realiza escaneos de seguridad de dependencias, imágenes Docker y archivos Terraform utilizando Snyk.

3. **Despliegue con Terraform**:
   - Despliega la infraestructura en AWS utilizando Terraform.

## Configuración del Pipeline

### Triggers

El pipeline se ejecuta automáticamente en los siguientes eventos:
- **Push** a la rama `main`.
- **Pull Request** a la rama `main`.

### Variables de Entorno

Asegúrate de tener configuradas las siguientes variables y secretos en tu repositorio de GitHub:

- `AWS_ACCESS_KEY_ID`: Clave de acceso de AWS.
- `AWS_SECRET_ACCESS_KEY`: Clave secreta de AWS.
- `MY_AWS_REGION`: Región de AWS.
- `ECR_REPOSITORY`: Nombre del repositorio de Amazon ECR.
- `SNYK_TOKEN`: Token de autenticación de Snyk.
- `TERRAFORM_CLOUD_TOKEN`: Token de API de Terraform Cloud.
- `EC2_SSH_KEY`: Clave SSH para acceso a las instancias EC2.
- `ECR_REPOSITORY_DOCKER`: Nombre del repositorio de ECR para Docker.

## Jobs del Pipeline

### 1. **Docker Build and Push**

Este trabajo realiza las siguientes acciones:
- Checkout del código fuente.
- Configuración de las credenciales de AWS.
- Creación del repositorio ECR (si no existe).
- Login a Amazon ECR.
- Configuración de Docker Buildx.
- Cacheo de capas de Docker.
- Build y push de la imagen Docker a ECR.

### 2. **Security Scan**

Este trabajo realiza las siguientes acciones:
- Checkout del código fuente.
- Configuración de las credenciales de AWS.
- Login a Amazon ECR.
- Instalación y autenticación con Snyk CLI.
- Escaneo de dependencias, imágenes Docker y archivos Terraform con Snyk.

### 3. **Terraform Deploy**

Este trabajo realiza las siguientes acciones:
- Checkout del código fuente.
- Configuración de las credenciales de AWS.
- Configuración de Terraform.
- Creación del archivo `terraform.tfvars`.
- Inicialización, planificación y aplicación de Terraform.
- Eliminación del archivo `terraform.tfvars` y la clave privada temporal.

## Ejecución del Pipeline

El pipeline se ejecuta automáticamente en los siguientes eventos:
- **Push** a la rama `main`.
- **Pull Request** a la rama `main`.

### Ejecución Manual

Puedes ejecutar el pipeline manualmente haciendo un push a la rama `main` o creando un pull request hacia la misma.

## GitHub Actions Workflow

El archivo `.github/workflows/deploy.yml` configura los jobs que describen el pipeline:

```yaml
name: Despliegue de aplicaciones

on:
  push:
    branches: [main]

jobs:
  snyk-security-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout del código
        uses: actions/checkout@v3

      - name: Instalar Snyk CLI
        run: npm install -g snyk

      - name: Authenticate Snyk CLI
        run: snyk auth ${{ secrets.SNYK_TOKEN }}
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}

      - name: Scan IAC code
        run: snyk iac test ./Terraform/** --severity-threshold=high

  deploy-terraform-app:
    runs-on: ubuntu-latest
    needs: snyk-security-scan
    steps:
      - name: Checkout del código
        uses: actions/checkout@v3

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.MY_AWS_REGION }}

      - name: Instalar Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Configurar credenciales de Terraform Cloud
        run: |
          mkdir -p ~/.terraform.d
          echo "{\"credentials\":{\"app.terraform.io\":{\"token\":\"${{ secrets.TERRAFORM_CLOUD_TOKEN }}\"}}}" > ~/.terraform.d/credentials.tfrc.json

      - name: Terraform Init
        run: terraform -chdir="./Terraform/" init

      - name: Terraform Plan
        run: terraform -chdir="./Terraform/" plan

      - name: Terraform Apply
        run: terraform -chdir="./Terraform/" apply -auto-approve

      - name: Obtener dirección IP pública del EC2
        id: output
        run: |
          public_ip=$(terraform -chdir='./Terraform/' output -raw ec2_public_ip)
          echo "::set-output name=public_ip::$public_ip"

      - name: Configurar clave SSH
        run: |
          echo "${{ secrets.EC2_SSH_KEY }}" > /tmp/id_rsa
          chmod 400 /tmp/id_rsa

      - name: Verificar conexión SSH
        run: |
          echo "Verificando conexión SSH a EC2..."
          ssh -o StrictHostKeyChecking=no -i /tmp/id_rsa ec2-user@${{ steps.output.outputs.public_ip }} "echo 'Conexión exitosa'"

      - name: Copiar aplicación al EC2
        run: |
          echo "Copiando archivos al EC2..."
          ssh -o StrictHostKeyChecking=no -i /tmp/id_rsa ec2-user@${{ steps.output.outputs.public_ip }} "mkdir -p /home/ec2-user/app"
          scp -o StrictHostKeyChecking=no -i /tmp/id_rsa -r ./App ec2-user@${{ steps.output.outputs.public_ip }}:/home/ec2-user/app

      - name: Instalar Nginx y configurar para servir archivos estáticos
        run: |
          echo "Instalando Nginx y configurando servidor para archivos estáticos..."
          ssh -o StrictHostKeyChecking=no -i /tmp/id_rsa ec2-user@${{ steps.output.outputs.public_ip }} << 'EOF'
            
            sudo amazon-linux-extras enable nginx1
            sudo yum install -y nginx
            sudo systemctl enable nginx
            sudo systemctl start nginx
            sudo mkdir -p /var/www/landingpage
            sudo cp -r /home/ec2-user/app/App/* /var/www/landingpage/
            sudo mkdir -p /etc/nginx/conf.d
            sudo tee /etc/nginx/conf.d/default.conf > /dev/null <<EOL
            server {
              listen 80;
              root /var/www/landingpage;
              index index.html;
              location / {
                  try_files \$uri \$uri/ =404;
              }
              error_page 404 /404.html;
            }
            EOL
            sudo nginx -s reload
          EOF

  deploy-docker-app:
    runs-on: ubuntu-latest
    needs: deploy-terraform-app
    steps:
      - name: Checkout del código
        uses: actions/checkout@v3

      - name: Instalar Snyk CLI
        run: npm install -g snyk

      - name: Authenticate Snyk CLI
        run: snyk auth ${{ secrets.SNYK_TOKEN }}
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}

      - name: Login a Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1

      - name: Crear repositorio ECR si no existe
        run: |
          aws ecr describe-repositories --repository-names ${{ secrets.ECR_REPOSITORY_DOCKER }} || \
          aws ecr create-repository --repository-name ${{ secrets.ECR_REPOSITORY_DOCKER }} --region ${{ secrets.MY_AWS_REGION }}

      - name: Build de la imagen Docker
        id: build-image
        uses: docker/build-push-action@v3
        with:
          context: ./Docker
          file: ./Docker/Dockerfile
          push: false
          tags: ${{ steps.login-ecr.outputs.registry }}/${{ secrets.ECR_REPOSITORY_DOCKER }}:latest

      - name: Escaneo de la imagen Docker con Snyk
        continue-on-error: true
        run: |
          snyk container test ${{ steps.login-ecr.outputs.registry }}/${{ secrets.ECR_REPOSITORY_DOCKER }}:latest \
          --severity-threshold=high || true
          snyk container monitor ${{ steps.login-ecr.outputs.registry }}/${{ secrets.ECR_REPOSITORY_DOCKER }}:latest || true

      - name: Push de la imagen Docker
        if: ${{ success() }}
        uses: docker/build-push-action@v3
        with:
          context: ./Docker
          file: ./Docker/Dockerfile
          push: true
          tags: ${{ steps.login-ecr.outputs.registry }}/${{ secrets.ECR_REPOSITORY_DOCKER }}:latest
