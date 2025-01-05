output "route_table_id" {
  value = aws_route_table.public.id
  description = "ID de la tabla de rutas pública"
}