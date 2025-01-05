output "instance_id" {
  value = aws_instance.ec2-prueba-final.id
  description = "ID de la instancia EC2"
}

output "instance_public_ip" {
  value = aws_instance.ec2-prueba-final.public_ip
  description = "IP pública de la instancia EC2"
}