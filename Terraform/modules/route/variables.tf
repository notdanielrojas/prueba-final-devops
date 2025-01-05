variable "vpc_id" {
  type = string
  description = "ID de la VPC"
}

variable "igw_id" {
  type = string
  description = "ID del Internet Gateway"
}

variable "subnet_id" {
  type = string
  description = "ID de la subred a asociar"
}

variable "route_table_name" {
  type = string
  description = "Nombre de la tabla de rutas"
  default = "route-table-public"
}