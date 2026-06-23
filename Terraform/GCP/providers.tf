
# Bloque de configuración general de Terraform para el entorno de GCP
terraform {
  required_providers {
    google = {
      # Indica el origen oficial del proveedor de Google Cloud
      source = "hashicorp/google"
      # Usaremos cualquier versión estable dentro de la rama 5.x
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Configuración del proveedor específico (Google Cloud)
provider "google" {
  project = var.project_id # ID dinámico tomado de variables.tf
  region  = var.gcp_region # Región dinámica corregida

  # Construye la zona automáticamente combinando la región con la letra 'a'
  # Ej: "us-central1" + "-a" = "us-central1-a"
  zone = "${var.gcp_region}-a"
}
