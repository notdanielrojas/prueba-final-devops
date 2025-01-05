variable "sg_name" {
  type = string
  description = "Nombre del grupo de seguridad"
  default = "prueba-final-sg"
}

variable "vpc_id" {
  type = string
  description = "ID de la VPC"
}