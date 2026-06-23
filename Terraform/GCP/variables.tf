
# Definición de variables para la infraestructura de GCP

variable "project_id" {
  description = "El ID único del proyecto de Google Cloud donde se desplegará la infraestructura"
  type        = string
  default     = "ul-prueba"
}

variable "gcp_region" {
  description = "Región geográfica de GCP (datacenter) donde se ubicarán los recursos"
  type        = string
  default     = "us-central1"
}

variable "aws_account_id" {
  description = "El ID de la cuenta de AWS para configurar la relación de confianza de Workload Identity Federation"
  type        = string
  default     = "451620994923"
}

