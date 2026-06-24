# Bloque de salida (Output) para visualizar información útil en la terminal
output "detalles_red_servidores" {
  description = "Direcciones IP y DNS de la infraestructura desplegada en AWS"

  value = {
    "Server-1 (Web/API - Publico)" = {
      ip_publica  = aws_instance.vm_web.public_ip
      ip_privada  = aws_instance.vm_web.private_ip
      dns_interno = aws_instance.vm_web.private_dns
    }
    "Server-2 (PostgreSQL - Privado)" = {
      ip_privada   = aws_instance.vm_db.private_ip
      dns_interno  = aws_instance.vm_db.private_dns
    }
  }
}
