output "public_subnet_id" {
  value = aws_subnet.public.id
  description = "ID de la subred pública"
}

output "private_subnet_id" {
  value = aws_subnet.private.id
  description = "ID de la subred privada"
}