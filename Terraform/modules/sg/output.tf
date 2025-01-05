output "security_group_id" {
  value = aws_security_group.prueba-final-sg.id
  description = "ID del grupo de seguridad"
}