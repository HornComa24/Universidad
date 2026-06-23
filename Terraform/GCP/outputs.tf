# =========================================================================
# OUTPUTS PARA CONEXIÓN Y METADATOS DE GCP
# =========================================================================

# 1. Metadatos dinámicos del proyecto necesarios para Workload Identity en AWS
data "google_project" "project" {}

output "gcp_project_number" {
  description = "El número único del proyecto de GCP (necesario para configurar el audience en AWS)"
  value       = data.google_project.project.number
}

output "gcp_project_id" {
  description = "El ID de texto del proyecto de GCP"
  value       = var.project_id
}

# 2. Infraestructura de Red (Salida original para VPN)
output "gcp_vpn_public_ip" {
  description = "IP pública estática reservada en GCP para el Gateway de VPN"
  value       = google_compute_address.gcp_vpn_ip.address
}

# 3. Datos de Backup y Credenciales para AWS WIF
output "gcp_bucket_name" {
  description = "El nombre único del bucket de Google Cloud Storage"
  value       = google_storage_bucket.respaldos_nube_b.name
}

output "gcp_sa_email" {
  description = "El email de la cuenta de servicio de GCP a ser impersonada por AWS"
  value       = google_service_account.aws_backup_sa.email
}

output "gcp_pool_id" {
  description = "El ID del Workload Identity Pool creado en GCP"
  value       = google_iam_workload_identity_pool.aws_pool.workload_identity_pool_id
}

output "gcp_provider_id" {
  description = "El ID del Workload Identity Provider creado en GCP"
  value       = google_iam_workload_identity_pool_provider.aws_provider.workload_identity_pool_provider_id
}
