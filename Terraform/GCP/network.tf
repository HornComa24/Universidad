# =========================================================================
# 1. ARQUITECTURA DE RED CORE (VPC Y SUBRED)
# =========================================================================

# Red Virtual (VPC) para el entorno de respaldo en GCP
resource "google_compute_network" "gcp_vpc" {
  name                    = "gcp-vpc-backup"
  auto_create_subnetworks = false # Desactiva la creación automática para evitar desorden de IPs
}

# Subred dedicada (Aislada del rango 10.0.0.0/16 de AWS para evitar colisiones)
resource "google_compute_subnetwork" "gcp_subred" {
  name          = "gcp-subred-backup"
  ip_cidr_range = "10.1.0.0/24"
  network       = google_compute_network.gcp_vpc.id
  region        = var.gcp_region # Corregido para usar el nuevo nombre de variable
}


# =========================================================================
# 2. COMPONENTES DE CONECTIVIDAD HÍBRIDA (VPN GATEWAY)
# =========================================================================

# Reservar una dirección IP pública estática en GCP para el Gateway de VPN
resource "google_compute_address" "gcp_vpn_ip" {
  name   = "gcp-vpn-ip"
  region = var.gcp_region # Corregido para usar el nuevo nombre de variable
}

# Enrutador/Gateway de VPN clásico en Google Cloud
resource "google_compute_vpn_gateway" "gcp_gateway" {
  name    = "gcp-vpn-gateway"
  network = google_compute_network.gcp_vpc.id
}
