#!/bin/bash
# =========================================================================
# SCRIPT DE DESPLIEGUE AUTOMATIZADO PARA AWS (INTEGRACIÓN MULTI-CLOUD)
# =========================================================================
# Este script extrae de forma automática la llave de la cuenta de servicio 
# y el bucket creados en GCP, y los inyecta en el despliegue de AWS.

# Colores para la terminal
VERDE='\033[0;32m'
ROJO='\033[0;31m'
AZUL='\033[0;34m'
NC='\033[0m' # Sin color

echo -e "${AZUL}[+] Leyendo outputs del despliegue de GCP...${NC}"

# Extraer las variables de la carpeta de GCP
GCP_SA_EMAIL=$(terraform -chdir=../GCP output -raw gcp_sa_email 2>/dev/null)
GCP_PROJECT_NUMBER=$(terraform -chdir=../GCP output -raw gcp_project_number 2>/dev/null)
GCP_POOL_ID=$(terraform -chdir=../GCP output -raw gcp_pool_id 2>/dev/null)
GCP_PROVIDER_ID=$(terraform -chdir=../GCP output -raw gcp_provider_id 2>/dev/null)
GCP_BUCKET=$(terraform -chdir=../GCP output -raw gcp_bucket_name 2>/dev/null)

# Validar que los datos de GCP existan
if [ -z "$GCP_SA_EMAIL" ] || [ -z "$GCP_PROJECT_NUMBER" ] || [ -z "$GCP_POOL_ID" ] || [ -z "$GCP_PROVIDER_ID" ] || [ -z "$GCP_BUCKET" ]; then
    echo -e "${ROJO}[!] ERROR: No se pudieron obtener los datos de Workload Identity (WIF) o el bucket de GCP.${NC}"
    echo -e "${ROJO}Asegúrese de haber ejecutado 'terraform apply' en la carpeta GCP primero.${NC}"
    exit 1
fi

echo -e "${VERDE}[✓] Datos de Workload Identity (WIF) de GCP obtenidos correctamente.${NC}"
echo -e "${AZUL}[+] Inicializando y aplicando configuración en AWS...${NC}"

# Inicializar y aplicar en AWS
terraform init
terraform apply -auto-approve \
  -var="gcp_sa_email=$GCP_SA_EMAIL" \
  -var="gcp_project_number=$GCP_PROJECT_NUMBER" \
  -var="gcp_pool_id=$GCP_POOL_ID" \
  -var="gcp_provider_id=$GCP_PROVIDER_ID" \
  -var="gcp_backup_bucket=$GCP_BUCKET" "$@"
