# =========================================================================
# 1. CORE DE RED (VPC, SUBREDS E INTERNET GATEWAY)
# =========================================================================

# VPC principal para el entorno de servidores
resource "aws_vpc" "mi_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true # Asegura el soporte de resolución DNS interna de AWS
  enable_dns_hostnames = true # Crucial para que las EC2 obtengan un DNS público válido

  tags = {
    Name = "vpc-principal-aws"
  }
}

# Definición de las subredes de la VPC
resource "aws_subnet" "mis_subredes" {
  # Crea 2 subredes automáticamente basándose en el índice (0 y 1)
  count = 2
  # Asocia cada subred a la VPC que creamos arriba
  vpc_id = aws_vpc.mi_vpc.id
  # Asigna un rango de IP único a cada una (10.0.0.0/24 y 10.0.1.0/24)
  cidr_block = "10.0.${count.index}.0/24"
  # Distribuye las subredes en diferentes zonas para alta disponibilidad
  availability_zone = var.zonas[count.index]

  tags = {
    Name = "subnet-publica-${count.index + 1}"
  }
}

# Crear el Internet Gateway para dar acceso hacia y desde internet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.mi_vpc.id

  tags = {
    Name = "igw-principal"
  }
}


# =========================================================================
# 2. ENRUTAMIENTO (TABLAS DE RUTAS Y ASOCIACIONES)
# =========================================================================

# Asegurarte de que la tabla de rutas de tu subred tenga la ruta al internet (0.0.0.0/0)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.mi_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "tabla-rutas-publica"
  }
}

# Asociar la tabla de rutas a tus subredes de forma dinámica
resource "aws_route_table_association" "a" {
  count          = 2
  subnet_id      = aws_subnet.mis_subredes[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
