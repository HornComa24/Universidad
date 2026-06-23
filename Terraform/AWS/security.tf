# Obtener la IP pública actual del PC que ejecuta Terraform
data "http" "mi_ip_publica" {
  url = "https://ipv4.icanhazip.com"
}

# =========================================================================
# 1. CONFIGURACIÓN DEL FIREWALL (SECURITY GROUP)
# =========================================================================

resource "aws_security_group" "sg_web" {
  name        = "sg_web_servidores"
  description = "Permitir SSH, HTTP y trafico interno para servidores web"
  vpc_id      = aws_vpc.mi_vpc.id # Asegúrate de que en main.tf o network.tf tu VPC se llame mi_vpc

  # Acceso SSH restringido a orígenes conocidos
  ingress {
    description = "SSH desde origen restringido"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      var.ssh_allowed_cidr == "detect" ? "${chomp(data.http.mi_ip_publica.response_body)}/32" : var.ssh_allowed_cidr
    ]
  }

  # Acceso SSH exclusivo para el rango de la subred de GCP (Federación/VPN)
  ingress {
    description = "SSH desde la red de backup de GCP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/24"]
  }

  # Acceso HTTP para probar el servicio web Apache
  ingress {
    description = "Trafico HTTP comercial"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Acceso HTTPS para tráfico seguro comercial
  ingress {
    description = "Trafico HTTPS seguro comercial"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitir que las máquinas se hablen entre sí internamente sin restricciones
  ingress {
    description = "Comunicacion interna completa entre instancias del SG"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # Salida permitida a internet (esencial para que rclone llegue a las APIs públicas de GCP)
  egress {
    description = "Salida total a Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-web-servidores"
  }
}
