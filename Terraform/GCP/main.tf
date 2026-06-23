# =========================================================================
# 1. GESTIÓN DE IDENTIDAD (CUENTA DE SERVICIO E IAM)
# =========================================================================

# Crear la cuenta de servicio en GCP
resource "google_service_account" "aws_backup_sa" {
  account_id   = "aws-backup-servidor"
  display_name = "Cuenta de Servicio para Backups desde AWS"
}

# Asignar permisos de administración de objetos en Storage [cite: 8]
resource "google_project_iam_member" "sa_storage_permiso" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.aws_backup_sa.email}"
}

# Generar un sufijo aleatorio para evitar colisiones por borrado lógico (soft-delete de 30 días en GCP)
resource "random_id" "wif_pool_suffix" {
  byte_length = 4
}

resource "google_iam_workload_identity_pool" "aws_pool" {
  workload_identity_pool_id = "aws-backup-pool-${random_id.wif_pool_suffix.hex}"
  display_name              = "AWS Backup Pool"
  description               = "Workload Identity Pool para respaldos desde AWS sin llaves estaticas"
}

resource "google_iam_workload_identity_pool_provider" "aws_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.aws_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "aws-backup-provider"
  display_name                       = "AWS Backup Provider"
  description                        = "Proveedor de identidad federada para AWS"

  attribute_mapping = {
    "google.subject"     = "assertion.arn"
    "attribute.aws_role" = "assertion.arn.contains('assumed-role') ? 'arn:aws:iam::' + assertion.account + ':role/' + assertion.arn.extract('assumed-role/{role_name}/') : assertion.arn"
  }

  aws {
    account_id = var.aws_account_id
  }
}

# Permitir que el rol de AWS asuma la cuenta de servicio de GCP a traves de WIF
resource "google_service_account_iam_member" "wif_user" {
  service_account_id = google_service_account.aws_backup_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.aws_pool.name}/attribute.aws_role/arn:aws:iam::${var.aws_account_id}:role/ec2-backup-to-gcp-role"
}


# =========================================================================
# 2. ALMACENAMIENTO DE RESPALDOS (BUCKET)
# =========================================================================

# Generar un sufijo aleatorio para asegurar la unicidad del bucket en GCP
resource "random_id" "gcp_bucket_suffix" {
  byte_length = 4
}

# Bucket de almacenamiento NEARLINE [cite: 12]
resource "google_storage_bucket" "respaldos_nube_b" {
  name                        = "respaldos-nube-b-${random_id.gcp_bucket_suffix.hex}"
  location                    = "US"
  storage_class               = "NEARLINE"
  uniform_bucket_level_access = true
  force_destroy               = true

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }
}
