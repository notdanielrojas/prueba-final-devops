variable "cidr_block" {
  type = string
  description = "CIDR block de la VPC"
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type = string
  description = "Nombre de la VPC"
  default = "vpc-prueba-final"
}