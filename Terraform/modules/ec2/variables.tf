variable "ami_id" {
  type = string
  description = "ID de la AMI a utilizar"
  default = "ami-0ca9fb66e076a6e32"
}

variable "instance_type" {
  type = string
  description = "Tipo de instancia EC2"
  }

variable "security_group_ids" {
  type    = list(string)
  description = "IDs de los grupos de seguridad"
}

variable "subnet_id" {
  type = string
  description = "ID de la subred"
}

variable "instance_name" {
  type = string
  description = "Nombre de la instancia"
  default = "ec2-prueba-final"
}

variable "key_name" {
  type = string
  description = "Nombre del par de claves SSH"
  default = "key-cursodevops"
}