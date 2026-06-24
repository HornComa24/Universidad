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
    Name = count.index == 0 ? "subnet-publica" : "subnet-privada"
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
# 2. ENRUTAMIENTO Y CONECTIVIDAD (NAT GATEWAY PARA SUBRED PRIVADA)
# =========================================================================

# Tabla de rutas para la Subred Pública (Hacia Internet Gateway)
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

# Asociar tabla pública a Subred 1 (Pública)
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.mis_subredes[0].id
  route_table_id = aws_route_table.public_rt.id
}

# Reservar IP elástica para el NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "eip-nat-gateway"
  }
}

# Crear NAT Gateway en la subred pública para dar salida segura a la privada
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.mis_subredes[0].id # Debe estar en la subred pública
  depends_on    = [aws_internet_gateway.gw]

  tags = {
    Name = "nat-gateway-principal"
  }
}

# Tabla de rutas para la Subred Privada (Hacia NAT Gateway)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.mi_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "tabla-rutas-privada"
  }
}

# Asociar tabla privada a Subred 2 (Privada)
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.mis_subredes[1].id
  route_table_id = aws_route_table.private_rt.id
}

