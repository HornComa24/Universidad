
# =========================================================================
# RECURSOS GLOBALES DE ALMACENAMIENTO Y ACCESO SEGURO (AWS)
# =========================================================================

# 1. Generar un sufijo aleatorio para asegurar que el bucket sea único a nivel mundial
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# 2. Bucket de S3 principal para almacenamiento local en AWS
resource "aws_s3_bucket" "storage_principal" {
  bucket        = "almacenamiento-principal-${random_id.bucket_suffix.hex}"
  force_destroy = true # Permite borrar el bucket con datos al hacer destroy

  tags = {
    Name        = "s3-storage-principal"
    Environment = "Laboratorio"
  }
}

# 3. Almacenamiento seguro en AWS Systems Manager (SSM) Parameter Store
# (El parámetro de la llave de GCP fue removido porque ahora se utiliza Workload Identity Federation)

resource "aws_ssm_parameter" "gcp_backup_bucket" {
  name        = "/config/gcp/backup-bucket"
  description = "Nombre del bucket en GCP Cloud Storage para backups"
  type        = "String"
  value       = var.gcp_backup_bucket
  overwrite   = true

  tags = {
    Name        = "gcp-backup-bucket-name"
    Environment = "Laboratorio"
  }
}

resource "aws_ssm_parameter" "script_backup_gcp" {
  name        = "/scripts/backup_gcp"
  description = "Script para realizar el backup cifrado y subirlo a GCP"
  type        = "String"
  value       = file("${path.module}/scripts/backup_gcp.sh")
  overwrite   = true
}

resource "aws_ssm_parameter" "script_restore_gcp" {
  name        = "/scripts/restore_gcp"
  description = "Script para listar, descargar, descifrar y restaurar bases de datos desde GCP"
  type        = "String"
  value       = file("${path.module}/scripts/restore_gcp.sh")
  overwrite   = true
}

# =========================================================================
# EMPAQUETADO Y SUBIDA DE LA APLICACIÓN DOCKER A S3
# =========================================================================

data "archive_file" "docker_app_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../Docker/DOCKER-academic-managment"
  output_path = "${path.module}/docker_app.zip"
}

resource "aws_s3_object" "docker_app_upload" {
  bucket = aws_s3_bucket.storage_principal.id
  key    = "docker_app.zip"
  source = data.archive_file.docker_app_zip.output_path
  etag   = data.archive_file.docker_app_zip.output_sha
}



