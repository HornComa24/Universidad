# =========================================================================
# SCRIPT DE DESPLIEGUE AUTOMATIZADO PARA AWS (COMPATIBLE CON WINDOWS - POWERSHELL)
# =========================================================================
# Este script extrae de forma automática la información de cuenta de servicio,
# WIF y bucket creados en GCP, e inyecta estos valores en el despliegue de AWS.

$ErrorActionPreference = "Stop"

Write-Host "[+] Leyendo outputs del despliegue de GCP desde ../GCP..." -ForegroundColor Cyan

# Extraer las variables de la carpeta de GCP utilizando terraform output
try {
    $GCP_SA_EMAIL = (terraform -chdir=../GCP output -raw gcp_sa_email 2>$null).Trim()
    $GCP_PROJECT_NUMBER = (terraform -chdir=../GCP output -raw gcp_project_number 2>$null).Trim()
    $GCP_POOL_ID = (terraform -chdir=../GCP output -raw gcp_pool_id 2>$null).Trim()
    $GCP_PROVIDER_ID = (terraform -chdir=../GCP output -raw gcp_provider_id 2>$null).Trim()
    $GCP_BUCKET = (terraform -chdir=../GCP output -raw gcp_bucket_name 2>$null).Trim()
} catch {
    Write-Host "[!] ERROR: Ocurrió un error al intentar leer la configuración de GCP." -ForegroundColor Red
    Write-Host "Asegúrese de que Terraform esté instalado y que haya ejecutado 'terraform apply' en la carpeta GCP primero." -ForegroundColor Red
    Exit 1
}

# Validar que los datos de GCP existan y no estén vacíos
if ([string]::IsNullOrEmpty($GCP_SA_EMAIL) -or 
    [string]::IsNullOrEmpty($GCP_PROJECT_NUMBER) -or 
    [string]::IsNullOrEmpty($GCP_POOL_ID) -or 
    [string]::IsNullOrEmpty($GCP_PROVIDER_ID) -or 
    [string]::IsNullOrEmpty($GCP_BUCKET)) {
    
    Write-Host "[!] ERROR: No se pudieron obtener los datos de Workload Identity (WIF) o el bucket de GCP." -ForegroundColor Red
    Write-Host "Asegúrese de haber ejecutado 'terraform apply' en la carpeta GCP primero." -ForegroundColor Red
    Exit 1
}

Write-Host "[✓] Datos de Workload Identity (WIF) de GCP obtenidos correctamente:" -ForegroundColor Green
Write-Host "  - Service Account: $GCP_SA_EMAIL" -ForegroundColor Gray
Write-Host "  - Bucket de GCP: $GCP_BUCKET" -ForegroundColor Gray

Write-Host "[+] Inicializando y aplicando configuración en AWS..." -ForegroundColor Cyan

# Inicializar y aplicar en AWS pasando los parámetros capturados
terraform init

if ($args) {
    terraform apply -auto-approve `
      -var="gcp_sa_email=$GCP_SA_EMAIL" `
      -var="gcp_project_number=$GCP_PROJECT_NUMBER" `
      -var="gcp_pool_id=$GCP_POOL_ID" `
      -var="gcp_provider_id=$GCP_PROVIDER_ID" `
      -var="gcp_backup_bucket=$GCP_BUCKET" $args
} else {
    terraform apply -auto-approve `
      -var="gcp_sa_email=$GCP_SA_EMAIL" `
      -var="gcp_project_number=$GCP_PROJECT_NUMBER" `
      -var="gcp_pool_id=$GCP_POOL_ID" `
      -var="gcp_provider_id=$GCP_PROVIDER_ID" `
      -var="gcp_backup_bucket=$GCP_BUCKET"
}

Write-Host "[✓] ¡Despliegue multi-cloud completado con éxito!" -ForegroundColor Green
