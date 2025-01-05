resource "aws_vpc" "vpc_prueba-final" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
  }
  
}