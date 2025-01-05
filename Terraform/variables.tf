# Variables generales

variable "region" {
  type        = string
  description = "Región de AWS donde se desplegará la infraestructura"
  default     = "us-east-1"
}

variable "AWS_ACCESS_KEY_ID" {
  type        = string
  description = "ID de clave de acceso de AWS"
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "Clave de acceso secreto de AWS"
  sensitive   = true
}

# Variables para EC2

variable "ami_id" {
  type        = string
  description = "ID de la AMI a utilizar para la instancia EC2"
  default     = "ami-0ca9fb66e076a6e32"
}

variable "instance_type" {
  type        = string
  description = "Tipo de instancia EC2"
  default     = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "Nombre del par de claves SSH"
  default     = "key-cursodevops"
}

# Variables para la red (VPC, Subnets)

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block de la VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  type        = string
  description = "Nombre de la VPC"
  default     = "vpc-prueba-final"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block de la subred pública"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block de la subred privada"
  default     = "10.0.2.0/24"
}

# Variables para SNS

variable "email_address" {
  type        = string
  description = "Email address to subscribe to the SNS topic"
  default     = "danielrojasdop@gmail.com"
}

variable "topic_name" {
  type        = string
  description = "Name of the SNS topic"
  default     = "sns-prueba-final"
}

# Variables para Lambda

variable "lambda_role_name" {
  type        = string
  description = "The name of the IAM role for Lambda."
  default     = "lambda_exec_role"
}

variable "lambda_name" {
  type        = string
  description = "The name of the Lambda function."
  default     = "lambda-sqs-sns"
}

variable "lambda_filename" {
  type        = string
  description = "The filename of the Lambda zip file."
  default     = "./modules/lambda/src/lambda_function.zip"
}

variable "handler" {
  type        = string
  description = "The Lambda function handler."
  default     = "index.lambda_handler"
}

variable "runtime" {
  type        = string
  description = "The runtime for the Lambda function."
  default     = "python3.9"
}

variable "lambda_batch_size" {
  type        = number
  description = "Batch size for the Lambda trigger"
  default     = 10
}

variable "lambda_trigger_enabled" {
  type        = bool
  description = "Enable or disable the Lambda trigger"
  default     = true
}

variable "lambda_handler" {
  description = "El nombre del manejador de la función Lambda"
  type        = string
  default     = "index.lambda_handler"
}

variable "lambda_runtime" {
  description = "El entorno de ejecución de la función Lambda"
  type        = string
  default     = "python3.9"
}

variable "lambda_source_path" {
  description = "The source directory for the Lambda function code"
  type        = string
  default     = "./modules/lambda/src/lambda_function"
}

