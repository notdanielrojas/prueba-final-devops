# Proyecto de Automatización con GitHub Actions

Este proyecto utiliza GitHub Actions para automatizar el proceso de construcción, escaneo de seguridad y despliegue de una aplicación en AWS, usando Docker para contenerizar la aplicación y Terraform para aprovisionar la infraestructura en la nube.

## Descripción del flujo de trabajo

El pipeline de GitHub Actions está configurado para ejecutar los siguientes trabajos:

1. **Construcción y envío de Docker**:
   - Construye la imagen de Docker usando un Dockerfile multietapa.
   - Envía la imagen construida al Registro Elástico de Contenedores de Amazon (ECR).

2. **Escaneo de seguridad**:
   - Realiza escaneos de seguridad de dependencias, imágenes de Docker y archivos de Terraform utilizando Snyk.

3. **Despliegue con Terraform**:
   - Despliega la infraestructura en AWS utilizando Terraform.

## Configuración del pipeline

### Disparadores

El pipeline se ejecuta en los siguientes eventos:

- Push a la rama `main`.
- Solicitud de extracción a la rama `main`.

### Variables de entorno

- `AWS_REGION`: Región de AWS donde se desplegará la infraestructura.
- `ECR_REPOSITORY`: Nombre del repositorio ECR donde se enviará la imagen de Docker.
- `TF_VERSION`: Versión de Terraform que se utilizará para el despliegue.

## Trabajos

### 1. Construcción y envío de Docker

Este trabajo realiza las siguientes acciones:

- Checkout del código fuente del repositorio.
- Configuración de credenciales de AWS para acceder a los recursos.
- Creación del repositorio ECR si aún no existe.
- Inicio de sesión en Amazon ECR para enviar la imagen.
- Configuración de Docker Buildx para construir la imagen.
- Almacenamiento en caché de las capas de Docker para acelerar construcciones posteriores.
- Construcción y envío de la imagen de Docker a ECR.

### 2. Escaneo de seguridad

Este trabajo realiza las siguientes acciones:

- Checkout del código fuente del repositorio.
- Configuración de credenciales de AWS para acceder a los recursos.
- Inicio de sesión en Amazon ECR para escanear la imagen.
- Configuración de Node.js para ejecutar Snyk.
- Instalación de la interfaz de línea de comandos (CLI) de Snyk.
- Autenticación con Snyk utilizando un token de API.
- Escaneo de dependencias y de la imagen de Docker en ECR en busca de vulnerabilidades.
- Escaneo de archivos de Terraform utilizando Snyk para detectar posibles problemas de seguridad.

### 3. Despliegue de Terraform

Este trabajo realiza las siguientes acciones:

- Checkout del código fuente del repositorio.
- Configuración de credenciales de AWS para acceder a los recursos.
- Creación de una clave privada temporal para conexiones SSH seguras.
- Configuración de Terraform para el despliegue de la infraestructura.
- Almacenamiento en caché de los archivos de Terraform para acelerar despliegues posteriores.
- Creación del archivo `terraform.tfvars` con las variables específicas del despliegue.
- Inicialización, planificación y aplicación de Terraform para aprovisionar la infraestructura.
- Eliminación del archivo `terraform.tfvars` y de la clave privada temporal para mayor seguridad.

## Uso

Para utilizar este pipeline, debes configurar las siguientes variables y secretos en tu repositorio de GitHub:

- `AWS_ACCESS_KEY_ID`: Clave de acceso de AWS con permisos para acceder a los recursos necesarios.
- `AWS_SECRET_ACCESS_KEY`: Clave secreta de AWS correspondiente a la clave de acceso.
- `AWS_SESSION_TOKEN`: Token de sesión de AWS (opcional, necesario si se utilizan roles de IAM).
- `ECR_REPOSITORY`: Nombre del repositorio ECR donde se enviará la imagen de Docker.
- `SNYK_TOKEN`: Token de autenticación de Snyk para el escaneo de seguridad.
- `TF_API_TOKEN`: Token de API de Terraform Cloud para acceder al estado y la configuración de Terraform.
- `NOTIFICATION_EMAIL`: Dirección de correo electrónico donde se enviarán las notificaciones sobre el estado del pipeline.

### Ejecución del pipeline

El pipeline se ejecuta automáticamente cada vez que se realiza un push a la rama `main` o se crea una solicitud de extracción a la misma.

### Ejemplo de ejecución manual

Para ejecutar el pipeline manualmente, puedes realizar un push a la rama `main` o crear una solicitud de extracción a la misma. Esto iniciará el flujo de trabajo de GitHub Actions y ejecutará los trabajos de construcción, escaneo de seguridad y despliegue.