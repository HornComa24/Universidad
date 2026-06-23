
# Definición de variables para la infraestructura de AWS

variable "aws_region" {
  description = "Región de AWS donde se desplegarán todos los recursos"
  type        = string
  default     = "us-east-1"
}

variable "zonas" {
  description = "Lista de las zonas de disponibilidad para distribuir las subredes y asegurar alta disponibilidad"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "ruta_clave_publica" {
  description = "Ruta local a la clave pública SSH para acceder a las instancias"
  type        = string
  default     = ""
}

variable "gcp_sa_email" {
  description = "El email de la cuenta de servicio de GCP para impersonar"
  type        = string
  default     = ""
}

variable "gcp_project_number" {
  description = "El número único del proyecto de GCP"
  type        = string
  default     = ""
}

variable "gcp_pool_id" {
  description = "El ID del Workload Identity Pool de GCP"
  type        = string
  default     = "aws-backup-pool-v4"
}

variable "gcp_provider_id" {
  description = "El ID del Workload Identity Provider de GCP"
  type        = string
  default     = "aws-backup-provider"
}

variable "gcp_backup_bucket" {
  description = "Nombre del bucket de Google Cloud Storage para almacenar los backups"
  type        = string
  default     = "mi-proyecto-respaldo-backup-dr"
}

variable "ssh_allowed_cidr" {
  description = "CIDR de origen permitido para conexiones SSH. Si es 'detect', se detectará automáticamente tu IP pública actual."
  type        = string
  default     = "detect"
}
