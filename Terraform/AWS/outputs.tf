# Bloque de salida (Output) para visualizar información útil en la terminal
output "detalles_red_servidores" {
  description = "IPs y nombres DNS asignados por AWS"

  # Construye un mapa (objeto) con los datos de las instancias
  value = {
    for instance in aws_instance.vm_aws :

    # Si tiene el tag Name lo usa, si no, usa su ID de instancia para que nunca falle el bucle
    lookup(instance.tags, "Name", instance.id) => {
      ip_privada = instance.private_ip
      ip_publica = instance.public_ip
      dns        = instance.private_dns
    }
  }
}
