# Obtener la IP pública actual del PC que ejecuta Terraform
data "http" "mi_ip_publica" {
  url = "https://ipv4.icanhazip.com"
}

# =========================================================================
# 1. CONFIGURACIÓN DEL FIREWALL (SECURITY GROUP)
# =========================================================================

resource "aws_security_group" "sg_web" {
  name        = "sg_web_servidores"
  description = "Permitir SSH, HTTP/HTTPS publico para Server-1 (Web)"
  vpc_id      = aws_vpc.mi_vpc.id

  # Acceso SSH restringido a la IP del desarrollador (mínimo privilegio)
  ingress {
    description = "SSH desde origen restringido"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      var.ssh_allowed_cidr == "detect" ? "${chomp(data.http.mi_ip_publica.response_body)}/32" : var.ssh_allowed_cidr
    ]
  }

  # Acceso HTTP para probar el servicio web Apache (Etapa 4 & 5)
  ingress {
    description = "Trafico HTTP comercial publico"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Acceso HTTPS para tráfico seguro
  ingress {
    description = "Trafico HTTPS seguro publico"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Salida permitida a internet
  egress {
    description = "Salida total a Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-web-publico"
  }
}

# =========================================================================
# 2. GRUPO DE SEGURIDAD PARA BASE DE DATOS PRIVADA (Server-2) - MINIMO PRIVILEGIO
# =========================================================================

resource "aws_security_group" "sg_db" {
  name        = "sg_db_privado"
  description = "Aislar Server-2 bloqueando trafico de internet y aceptando solo peticiones de sg_web"
  vpc_id      = aws_vpc.mi_vpc.id

  # Permite SSH (22) únicamente desde el servidor web público (sg_web)
  ingress {
    description     = "SSH desde Bastion (Server-1)"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_web.id]
  }

  # Permite PostgreSQL (5432) únicamente desde el servidor web público (sg_web)
  ingress {
    description     = "PostgreSQL solo desde Server-1"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_web.id]
  }



  # Permite ICMP (ping) desde el servidor web público para probar conectividad (Etapa 4)
  ingress {
    description     = "Ping de diagnostico desde Server-1"
    from_port       = 8 # Tipo ICMP Echo Request
    to_port         = 0 # Código ICMP Echo Request es 0
    protocol        = "icmp"
    security_groups = [aws_security_group.sg_web.id]
  }

  # Salida permitida a internet (Crucial: pasa por NAT Gateway para subir backups a GCP o bajar paquetes)
  egress {
    description = "Salida total via NAT Gateway"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-db-privado"
  }
}
