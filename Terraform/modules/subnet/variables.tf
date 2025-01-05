variable "vpc_id" {
  type = string
  description = "ID de la VPC"
}

variable "public_subnet_cidr" {
  type = string
  description = "CIDR block de la subred pública"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type = string
  description = "CIDR block de la subred privada"
  default = "10.0.2.0/24"
}

variable "public_subnet_name" {
  type = string
  description = "Nombre de la subred pública"
  default = "subnet-public"
}

variable "private_subnet_name" {
  type = string
  description = "Nombre de la subred privada"
  default = "subnet-private"
}