resource "aws_internet_gateway" "igw-prueba-final" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.igw_name
  }
}