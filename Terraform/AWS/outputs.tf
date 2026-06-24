# Bloque de salida (Output) para visualizar información útil en la terminal
output "detalles_red_servidores" {
  description = "IPs y nombres DNS asignados por AWS"

  value = {
    "Server-1" = {
      ip_privada = aws_instance.vm_web.private_ip
      ip_publica = aws_instance.vm_web.public_ip
      dns        = aws_instance.vm_web.private_dns
    }
    "Server-2" = {
      ip_privada = aws_instance.vm_db.private_ip
      ip_publica = aws_instance.vm_db.public_ip
      dns        = aws_instance.vm_db.private_dns
    }
  }
}
