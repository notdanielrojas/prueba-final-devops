locals {
  # Tags comunes para todos los recursos
  common_tags = {
    environment = "dev"
    project     = "prueba-final"
    managed_by = "terraform"
  }

  # Nombres de recursos
  vpc_name = "vpc-prueba-final"
  public_subnet_name = "subred-publica-prueba-final"
  private_subnet_name = "subred-privada-prueba-final"
  route_table_name = "tabla-rutas-publica-prueba-final"
  sg_name = "grupo-seguridad-prueba-final"
  sns_topic_name = "topico-sns-prueba-final"
  sqs_queue_name = "cola-sqs-prueba-final"

  # Configuraciones de red
  vpc_cidr_block = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"

  # Configuraciones de SNS
  email_address = "notdanielrojas@gmail.com"
}