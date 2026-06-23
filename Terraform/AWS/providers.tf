
# Bloque de configuración general de Terraform
terraform {
  # Define qué proveedores externos necesitamos y sus versiones
  required_providers {
    aws = {
      # Indica el origen del proveedor (HashiCorp es el creador oficial)
      source = "hashicorp/aws"
      # "~> 5.0" significa que usaremos cualquier versión 5.x (compatible)
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

# Configuración del proveedor específico (AWS)
provider "aws" {
  # Utiliza la variable definida en variables.tf en lugar de un valor fijo
  region = var.aws_region
}
