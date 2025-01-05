variable "vpc_id" {
  type = string
  description = "ID de la VPC"
}

variable "igw_name" {
  type = string
  description = "Nombre del Internet Gateway"
  default = "igw-prueba-final"
}